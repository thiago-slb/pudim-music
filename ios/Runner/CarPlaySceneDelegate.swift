import CarPlay
import Flutter
import UIKit

/// Canal com o Dart (`lib/audio/carplay_bridge.dart`), criado quando o Flutter inicia.
enum CarPlayBridge {
  static var channel: FlutterMethodChannel?
}

/// CarPlay: listas com as mesmas pastas do Android Auto (Tocadas recentemente, Curtidas,
/// Playlists, Álbuns, Artistas, Baixadas). Tocar abre a tela "Tocando agora" do sistema, que
/// usa os controles e as informações publicados pelo audio_service.
class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
  private var interfaceController: CPInterfaceController?
  private let images = NSCache<NSURL, UIImage>()

  func templateApplicationScene(
    _ templateApplicationScene: CPTemplateApplicationScene,
    didConnect interfaceController: CPInterfaceController
  ) {
    self.interfaceController = interfaceController
    let root = CPListTemplate(title: "Pudim", sections: [])
    interfaceController.setRootTemplate(root, animated: false, completion: nil)
    load(root, parent: "root")
  }

  func templateApplicationScene(
    _ templateApplicationScene: CPTemplateApplicationScene,
    didDisconnectInterfaceController interfaceController: CPInterfaceController
  ) {
    self.interfaceController = nil
  }

  // MARK: - Listas

  private func load(_ template: CPListTemplate, parent: String) {
    guard let channel = CarPlayBridge.channel else {
      // O Flutter ainda não subiu (app fechado no iPhone): avisa e tenta de novo.
      template.updateSections([Self.message(Self.text(.openApp))])
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self, weak template] in
        guard let self = self, let template = template, self.interfaceController != nil else { return }
        self.load(template, parent: parent)
      }
      return
    }
    channel.invokeMethod("children", arguments: parent) { [weak self, weak template] result in
      guard let self = self, let template = template else { return }
      let rows = (result as? [[String: Any]]) ?? []
      let items = rows.map { self.item(from: $0) }
      template.updateSections(
        items.isEmpty ? [Self.message(Self.text(.empty))] : [CPListSection(items: items)]
      )
    }
  }

  private func item(from row: [String: Any]) -> CPListItem {
    let id = row["id"] as? String ?? ""
    let title = row["title"] as? String ?? ""
    let subtitle = (row["subtitle"] as? String).flatMap { $0.isEmpty ? nil : $0 }
    let playable = row["playable"] as? Bool ?? false
    let item = CPListItem(text: title, detailText: subtitle)
    item.accessoryType = playable ? .none : .disclosureIndicator
    item.handler = { [weak self] _, completion in
      defer { completion() }
      guard let self = self else { return }
      if playable {
        CarPlayBridge.channel?.invokeMethod("play", arguments: id)
        self.showNowPlaying()
      } else {
        let next = CPListTemplate(title: title, sections: [])
        self.interfaceController?.pushTemplate(next, animated: true, completion: nil)
        self.load(next, parent: id)
      }
    }
    if let art = row["art"] as? String, let url = URL(string: art) {
      image(url) { item.setImage($0) }
    }
    return item
  }

  private func showNowPlaying() {
    guard let ic = interfaceController else { return }
    let np = CPNowPlayingTemplate.shared
    if ic.topTemplate === np { return }
    if ic.templates.contains(where: { $0 === np }) {
      ic.pop(to: np, animated: true, completion: nil)
    } else {
      ic.pushTemplate(np, animated: true, completion: nil)
    }
  }

  // MARK: - Capas

  private func image(_ url: URL, done: @escaping (UIImage) -> Void) {
    if let cached = images.object(forKey: url as NSURL) {
      done(cached)
      return
    }
    URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
      guard let data = data, let raw = UIImage(data: data) else { return }
      let size = CPListItem.maximumImageSize
      let img = UIGraphicsImageRenderer(size: size).image { _ in
        raw.draw(in: CGRect(origin: .zero, size: size))
      }
      self?.images.setObject(img, forKey: url as NSURL)
      DispatchQueue.main.async { done(img) }
    }.resume()
  }

  // MARK: - Textos (pt, es, en)

  private enum Text { case openApp, empty }

  private static func text(_ t: Text) -> String {
    let lang = String(Locale.preferredLanguages.first?.prefix(2) ?? "en")
    switch (t, lang) {
    case (.openApp, "pt"): return "Abra o Pudim no iPhone para começar"
    case (.openApp, "es"): return "Abre Pudim en el iPhone para empezar"
    case (.openApp, _): return "Open Pudim on your iPhone to start"
    case (.empty, "pt"): return "Nada por aqui"
    case (.empty, "es"): return "Nada por aquí"
    case (.empty, _): return "Nothing here"
    }
  }

  private static func message(_ text: String) -> CPListSection {
    CPListSection(items: [CPListItem(text: text, detailText: nil)])
  }
}
