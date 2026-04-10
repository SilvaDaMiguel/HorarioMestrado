import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
//PERMISSIONS
import 'package:permission_handler/permission_handler.dart';
//MODELS
import '../models/aula.dart';
import '../models/periodo.dart';
//FUNCTIONS
import '../functions.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    // Configura o fuso horário local (importante para Portugal)
    tz.setLocalLocation(tz.getLocation('Europe/Lisbon'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> agendarNotificacaoAula({
    required Aula aula,
    required Periodo periodo,
    required String nomeCadeira,
  }) async {
    // 1. Parsing da data da aula (assumindo formato YYYY-MM-DD)
    DateTime? dataBase = stringDDMMYYYYParaDateTime(aula.data);

    if (dataBase == null) {
      print("Erro: Formato de data inválido na aula.");
      return;
    }

    // 2. Parsing da hora de início "HH:MM"
    List<String> partesHora = periodo.horaInicio.split(':'); //
    int hora = int.parse(partesHora[0]);
    int minuto = int.parse(partesHora[1]);

    // 3. Criar o DateTime completo
    DateTime dataHoraCompleta = DateTime(
      dataBase.year,
      dataBase.month,
      dataBase.day,
      hora,
      minuto,
    );

    // Converter para o formato do Timezone
    final tz.TZDateTime agendamento = tz.TZDateTime.from(
      dataHoraCompleta,
      tz.local,
    ).subtract(const Duration(minutes: 10)); // TODO: Notificar 10 min antes

    // Evitar agendar se a hora já passou
    if (agendamento.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _notificationsPlugin.zonedSchedule(
      aula.id, // Usa o ID da aula como ID da notificação
      'Início de Aula: $nomeCadeira',
      'A aula começa às ${periodo.horaInicio} na sala ${aula.sala}', //
      agendamento,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'canal_aulas',
          'Notificações de Aulas',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      //androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, //Não precisa ser exato ao segundo 00
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelarNotificacao(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> verificarPermissaoNotificao() async {
    // Verifica o estado atual da permissão
    var status = await Permission.notification.status;

    if (status.isDenied) {
      // Pede a permissão ao utilizador
      final result = await Permission.notification.request();

      if (result.isGranted) {
        print("Permissão concedida");
      } else if (result.isPermanentlyDenied) {
        // O utilizador negou e clicou em "Não perguntar novamente"
        // Podes sugerir abrir as definições do sistema
        await openAppSettings();
      }
    }
  }

  Future<void> verificarPermissaoAlarmeExato() async {
    var status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      // Isto abre a página de definições específica do Android
      // onde o utilizador permite "Alarmes e Lembretes"
      await Permission.scheduleExactAlarm.request();
    }
  }
}
