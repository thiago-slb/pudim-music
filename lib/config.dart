/// Endereços padrão do app.
///
/// O código aberto não traz nenhum servidor: quem usa digita o endereço do Jellyfin na tela de entrar.
/// Para um build próprio já vir com os seus endereços preenchidos, copie `pudim.example.json` para
/// `pudim.local.json` (fica fora do git) e gere com `--dart-define-from-file=pudim.local.json`.
library;

/// Endereço principal do Jellyfin (o que funciona de qualquer rede), ex. `https://jellyfin.exemplo.com`.
const defaultServerUrl = String.fromEnvironment('PUDIM_SERVER_URL');

/// Endereço do Jellyfin na rede local (opcional). Quando responde, o app usa ele no lugar do principal.
const defaultLanUrl = String.fromEnvironment('PUDIM_SERVER_LAN_URL');

/// Servidor de extras do Pudim (opcional): chat, Jam, Blend, mixes, Retrospectiva, shows, podcasts,
/// Last.fm, pedidos de download e atualização automática. Sem ele, o app é um player do Jellyfin completo.
const defaultExtrasUrl = String.fromEnvironment('PUDIM_EXTRAS_URL');
