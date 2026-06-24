/// Sistema de notificação do Flext: uma mensagem dispara para **todos os
/// canais ativos** (push FCM, SMS/WhatsApp Twilio, e seus próprios canais).
library flext.notify;

export 'notification_center.dart';
export 'notification_channel.dart';
export 'notification_message.dart';
export 'channels/fcm_push_channel.dart';
export 'channels/twilio_sms_channel.dart';
export 'channels/twilio_whatsapp_channel.dart';
