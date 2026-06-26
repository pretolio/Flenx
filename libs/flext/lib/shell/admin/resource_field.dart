/// Tipo de entrada de um campo de recurso no admin genérico.
enum FieldKind { text, multiline, number, boolean, select, image }

/// Descreve UM campo de um recurso (produto, usuário, pedido...). O
/// [FlextResourcePage] usa a lista de campos para montar a tabela e o
/// formulário de criar/editar — sem você escrever UI específica.
class ResourceField {
  const ResourceField(
    this.key,
    this.label, {
    this.kind = FieldKind.text,
    this.options = const [],
    this.inTable = false,
    this.required = false,
    this.hint,
  });

  /// Chave no JSON/banco (ex.: `name`, `price`, `role`).
  final String key;
  final String label;
  final FieldKind kind;

  /// Opções quando [kind] é [FieldKind.select].
  final List<String> options;

  /// Se aparece como coluna na listagem.
  final bool inTable;

  /// Se é obrigatório no formulário.
  final bool required;
  final String? hint;
}
