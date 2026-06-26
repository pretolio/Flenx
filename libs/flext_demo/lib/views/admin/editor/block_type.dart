import 'package:flutter/material.dart';

/// Tipos de bloco que o editor de post (estilo G1) oferece. Espelha os
/// [PostBlock] da lib; cada um tem rótulo e ícone para o menu "adicionar".
enum BlockType {
  paragraph('Parágrafo', Icons.notes_outlined),
  heading('Subtítulo', Icons.title),
  image('Imagem', Icons.image_outlined),
  quote('Citação', Icons.format_quote),
  list('Lista', Icons.format_list_bulleted),
  embed('Vídeo / Embed', Icons.smart_display_outlined),
  divider('Divisor', Icons.horizontal_rule);

  const BlockType(this.label, this.icon);

  final String label;
  final IconData icon;
}
