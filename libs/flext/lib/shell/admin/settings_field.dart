/// Um campo editável da tela de configurações/home (chave no JSON + rótulo).
class SettingField {
  const SettingField(this.key, this.label, {this.multiline = false, this.hint});

  final String key;
  final String label;
  final bool multiline;
  final String? hint;
}
