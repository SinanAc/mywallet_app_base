
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationFunctions {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  //initialization of the notification
  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
    if (initScheduled){
      tz.initializeTimeZones();
      final loactionName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(loactionName));
    }
  }

  // //delete all notifications
  static Future<void> deleteAllNotifications() async {
    await notifications.cancelAll();
  }

  //show notification
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required int selectedHour,
    required int selectedMinute
  }) async =>
      notifications.zonedSchedule(
        id,
        title,
        body,
        scheduleDaily( Time(selectedHour,selectedMinute,0)),
        await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  //schedule daily notification
  static tz.TZDateTime scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
  }
}
