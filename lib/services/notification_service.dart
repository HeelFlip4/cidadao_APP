import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../constants/app_constants.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // Inicializar o serviço de notificações
  static Future<void> initialize() async {
    if (_initialized) return;

    // Configurações para Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configurações para iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Configurações gerais
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Criar canal de notificação para Android
    await _createNotificationChannel();

    _initialized = true;
  }

  // Criar canal de notificação (Android)
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Solicitar permissões de notificação
  static Future<bool> requestPermissions() async {
    // Verificar se já tem permissão
    final status = await Permission.notification.status;
    if (status.isGranted) return true;

    // Solicitar permissão
    final result = await Permission.notification.request();
    return result.isGranted;
  }

  // Callback quando notificação é tocada
  static void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      // Processar payload e navegar para tela específica
      _handleNotificationPayload(payload);
    }
  }

  // Processar payload da notificação
  static void _handleNotificationPayload(String payload) {
    // Implementar navegação baseada no payload
    // Por exemplo: navegar para detalhes da ocorrência
    // TODO: Implementar navegação específica baseada no payload
  }

  // Mostrar notificação simples
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Mostrar notificação de ocorrência atualizada
  static Future<void> showOcorrenciaUpdate({
    required String ocorrenciaId,
    required String titulo,
    required String status,
  }) async {
    await showNotification(
      id: ocorrenciaId.hashCode,
      title: 'Ocorrência Atualizada',
      body: '$titulo - Status: $status',
      payload: 'ocorrencia:$ocorrenciaId',
    );
  }

  // Mostrar notificação de nova vaga
  static Future<void> showNovaVaga({
    required String vagaId,
    required String titulo,
    required String categoria,
  }) async {
    await showNotification(
      id: vagaId.hashCode,
      title: 'Nova Vaga Disponível',
      body: '$titulo - $categoria',
      payload: 'vaga:$vagaId',
    );
  }

  // Mostrar notificação de notícia
  static Future<void> showNoticia({
    required String noticiaId,
    required String titulo,
    required String resumo,
  }) async {
    await showNotification(
      id: noticiaId.hashCode,
      title: 'Nova Notícia',
      body: '$titulo - $resumo',
      payload: 'noticia:$noticiaId',
    );
  }

  // Agendar notificação
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Converter DateTime para TZDateTime
    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTZDate,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Cancelar notificação específica
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancelar todas as notificações
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Obter notificações pendentes
  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Verificar se notificações estão habilitadas
  static Future<bool> areNotificationsEnabled() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Abrir configurações de notificação do sistema
  static Future<void> openNotificationSettings() async {
    await openAppSettings();
  }
}

// Tipos de notificação
enum NotificationType {
  ocorrenciaUpdate,
  novaVaga,
  noticia,
  lembrete,
}

// Modelo para dados de notificação
class NotificationData {
  final NotificationType type;
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic>? data;

  NotificationData({
    required this.type,
    required this.id,
    required this.title,
    required this.body,
    this.data,
  });

  String get payload {
    return '${type.name}:$id';
  }
}
