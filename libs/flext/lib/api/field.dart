/// Campo de entrada de um endpoint, com validação declarativa. A mesma regra é
/// aplicada no alvo Dart (runtime) e gerada no PHP.
class Field {
  const Field(
    this.name, {
    this.required = false,
    this.email = false,
    this.isInt = false,
    this.maxLength,
  });

  final String name;
  final bool required;
  final bool email;
  final bool isInt;
  final int? maxLength;

  /// Retorna a mensagem de erro, ou `null` se válido.
  String? validate(String? value) {
    final v = value?.trim() ?? '';
    if (required && v.isEmpty) return 'O campo "$name" é obrigatório.';
    if (v.isEmpty) return null;
    if (email && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
      return 'O campo "$name" deve ser um e-mail válido.';
    }
    if (isInt && int.tryParse(v) == null) {
      return 'O campo "$name" deve ser um número inteiro.';
    }
    if (maxLength != null && v.length > maxLength!) {
      return 'O campo "$name" excede $maxLength caracteres.';
    }
    return null;
  }
}
