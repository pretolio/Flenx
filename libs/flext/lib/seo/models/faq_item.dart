/// Par pergunta/resposta usado para gerar JSON-LD `FAQPage` (forte em AEO/GEO:
/// motores de resposta extraem perguntas estruturadas diretamente).
class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
