/// Notificação exibida no menu de notificações da top bar.
class AppNotification {
  const AppNotification({
    required this.title,
    required this.message,
    this.read = false,
  });

  final String title;
  final String message;
  final bool read;
}
