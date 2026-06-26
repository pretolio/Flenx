import 'package:jaspr/jaspr.dart';

/// Resultado da resolução de uma rota pelo app: o componente a renderizar e se
/// ele é uma **ilha Flutter** (precisa do bootstrap do Flutter no `<head>`).
class PageResult {
  const PageResult(this.body, {this.island = false});

  final Component body;
  final bool island;
}
