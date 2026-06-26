/// Frequência de mudança de uma URL no sitemap (spec sitemaps.org 0.9).
enum ChangeFreq {
  always('always'),
  hourly('hourly'),
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  yearly('yearly'),
  never('never');

  const ChangeFreq(this.value);

  /// Valor textual emitido no XML (`<changefreq>`).
  final String value;
}
