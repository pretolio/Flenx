import 'dart:convert';

/// Lead capturado pelo formulário de contato.
class Lead {
  const Lead({
    required this.name,
    required this.email,
    this.message = '',
    this.createdAt,
  });

  final String name;
  final String email;
  final String message;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'message': message,
    'createdAt': (createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .toIso8601String(),
  };

  String toJsonLine() => jsonEncode(toJson());

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    message: json['message'] as String? ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
  );

  bool get isValid => email.contains('@') && name.trim().isNotEmpty;
}
