/// Classificação de largura da viewport para o shell responsivo.
enum ShellLayout { mobile, tablet, desktop }

/// Breakpoints do shell. Por decisão de produto, **mobile E tablet** usam
/// drawer; apenas **desktop** mantém a sidebar fixa.
class ShellBreakpoints {
  const ShellBreakpoints._();

  /// A partir daqui é tablet.
  static const double tablet = 600;

  /// A partir daqui é desktop (sidebar fixa).
  static const double desktop = 1024;

  static ShellLayout of(double width) {
    if (width >= desktop) return ShellLayout.desktop;
    if (width >= tablet) return ShellLayout.tablet;
    return ShellLayout.mobile;
  }

  /// Mobile e tablet → sidebar vira drawer.
  static bool isDrawer(double width) => width < desktop;
}
