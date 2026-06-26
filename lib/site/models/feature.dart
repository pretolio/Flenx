/// Um recurso exibido na grade de features da landing (ícone + título + texto).
class Feature {
  const Feature({
    required this.icon,
    required this.title,
    required this.description,
  });

  /// Emoji ou caractere usado como ícone (sem depender de assets).
  final String icon;
  final String title;
  final String description;
}
