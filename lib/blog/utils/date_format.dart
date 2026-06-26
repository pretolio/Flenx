/// Formatação de datas para exibição no blog (pt-BR).
class DateFormatBr {
  const DateFormatBr._();

  /// Ex.: `23/06/2026`.
  static String short(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';
}
