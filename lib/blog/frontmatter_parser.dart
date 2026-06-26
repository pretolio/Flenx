import 'package:yaml/yaml.dart';

/// Resultado da separação de um arquivo markdown em frontmatter + corpo.
typedef ParsedContent = ({Map<String, dynamic> data, String body});

/// Separa o frontmatter YAML (entre `---`) do corpo markdown de um arquivo.
class FrontmatterParser {
  const FrontmatterParser();

  ParsedContent parse(String raw) {
    final text = raw.replaceAll('\r\n', '\n');
    if (!text.startsWith('---\n')) {
      return (data: const {}, body: text.trim());
    }
    final end = text.indexOf('\n---', 4);
    if (end == -1) {
      return (data: const {}, body: text.trim());
    }
    final fm = text.substring(4, end);
    final body = text.substring(end + 4).trimLeft();
    final yaml = loadYaml(fm);
    return (data: _toMap(yaml), body: body);
  }

  Map<String, dynamic> _toMap(dynamic yaml) {
    if (yaml is! YamlMap) return const {};
    return yaml.map((k, v) => MapEntry(k.toString(), _normalize(v)));
  }

  dynamic _normalize(dynamic v) {
    if (v is YamlList) return v.map(_normalize).toList();
    if (v is YamlMap) return _toMap(v);
    return v;
  }
}
