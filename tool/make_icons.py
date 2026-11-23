"""Gera os ícones do app a partir de assets/icon/pudim.png (quadrado, >= 1024px).

Uso: python tool/make_icons.py  (na raiz do repositório)
"""
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "assets" / "icon" / "pudim.png"


def rounded(img: Image.Image, radius_ratio: float = 0.22) -> Image.Image:
    """Cantos arredondados (estilo app do Windows/macOS) com fundo transparente."""
    img = img.convert("RGBA")
    w, h = img.size
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, w - 1, h - 1), int(w * radius_ratio), fill=255)
    img.putalpha(mask)
    return img


def main() -> None:
    base = Image.open(SRC).convert("RGBA")
    round_ = rounded(base)

    def save(img: Image.Image, rel: str, size: int) -> None:
        out = ROOT / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        img.resize((size, size), Image.LANCZOS).save(out)

    # Windows: .ico com vários tamanhos.
    round_.save(ROOT / "windows/runner/resources/app_icon.ico",
                sizes=[(s, s) for s in (16, 24, 32, 48, 64, 128, 256)])

    # macOS
    for s in (16, 32, 64, 128, 256, 512, 1024):
        save(round_, f"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_{s}.png", s)

    # Web
    save(round_, "web/favicon.png", 32)
    for s in (192, 512):
        save(round_, f"web/icons/Icon-{s}.png", s)
        save(base, f"web/icons/Icon-maskable-{s}.png", s)

    # Android (ícone legado, sem adaptive por enquanto)
    for d, s in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        save(round_, f"android/app/src/main/res/mipmap-{d}/ic_launcher.png", s)

    print("ícones gerados")


if __name__ == "__main__":
    main()
