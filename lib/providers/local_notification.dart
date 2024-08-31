import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sample_test_app_for_job/main.dart';
import 'package:sample_test_app_for_job/models/event.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNoti {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNoti() async {
    final initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // Ensure this icon is present
    final initializationSettingsIOS = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        // Parse the payload and navigate to the notification screen
        final payload = response.payload;
        // final desc = response.payload;
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => NotificationScreen(
              title: payload!,
              description: payload,
            ),
          ),
        );
      }
    });
  }

  static Future<void> showSimpleNoti() async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "basic notification",
        importance: Importance.max,
        priority: Priority.high,
        // Set other properties to avoid displaying the notification
        showWhen: false,
        sound: null,
        vibrationPattern: null,
        playSound: false,
      ),
    );
    await _flutterLocalNotificationsPlugin.show(
        0, "title", "body of the notification", details,
        payload: "Notification Payload");
  }

  static Future<void> showScheduledForEvent(Events event) async {
    int notificationId = event.id!;
    final payload = '${event.title}~${event.description}';
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id 2",
        "scheduled notification",
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        autoCancel: true,
        color: Color(0xFF8A4D1F),
        ledColor: Color(0xFF8A4D1F),
        ledOnMs: 1000,
        ledOffMs: 500,
        playSound: false, // Disable sound if you don't want notifications
      ),
    );

    tz.initializeTimeZones();
    final nowLocal = tz.TZDateTime.now(tz.local);
    final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
    final eventTime = event.startTime;
    final localScheduledTime = tz.TZDateTime(
      tz.local,
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventTime.hour - 3,
      eventTime.minute,
    );
    final futureScheduledTime = localScheduledTime.isBefore(nowLocal)
        ? localScheduledTime.add(const Duration(days: 1))
        : localScheduledTime;

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        event.title,
        event.description,
        futureScheduledTime,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

//! init
// static final FlutterLocalNotificationsPlugin
  //     _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // static onTap(details) {}
  // static Future initNoti() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final DarwinInitializationSettings initializationSettingsDarwin =
  //       DarwinInitializationSettings(
  //     onDidReceiveLocalNotification: (id, title, body, payload) => null,
  //   );
  //   const LinuxInitializationSettings initializationSettingsLinux =
  //       LinuxInitializationSettings(defaultActionName: 'Open notification');

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsDarwin,
  //     linux: initializationSettingsLinux,
  //   );

  //   try {
  //     await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //         onDidReceiveNotificationResponse: onTap,
  //         onDidReceiveBackgroundNotificationResponse: onTap);
  //     print('Notification plugin initialized successfully.');
  //   } catch (e) {
  //     print('Error initializing notification plugin: $e');
  //   }
  // }

//! from database
  //   static Future scheduleNotificationsFromDatabase() async {
  //   List<Events> events = await DatabaseHelper.instance.getAllEvents();

  //   for (Events event in events) {
  //     final nowLocal = tz.TZDateTime.now(tz.local); // Get current local time
  //     final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
  //     final eventTime = event.startTime;

  //     // Construct the local scheduled time
  //     final localScheduledTime = tz.TZDateTime(
  //       tz.local,
  //       eventDate.year,
  //       eventDate.month,
  //       eventDate.day,
  //       eventTime.hour - 3,
  //       eventTime.minute,
  //     );

  //     final futureScheduledTime = localScheduledTime.isBefore(nowLocal)
  //         ? localScheduledTime.add(Duration(days: 1))
  //         : localScheduledTime;

  //     print('Scheduled Time (Local): ${futureScheduledTime.toIso8601String()}');
  //     print('Current Time (Local): ${nowLocal.toIso8601String()}');

  //     try {
  //       await _flutterLocalNotificationsPlugin.zonedSchedule(
  //         0, // ID
  //         'Immediate Test Title',
  //         'This is a test notification scheduled 10 seconds from now.',
  //         tz.TZDateTime.now(tz.local).add(Duration(seconds: 10)),
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             'channel_id',
  //             'channel_name',
  //             channelDescription: 'channel_description',
  //             importance: Importance.max,
  //             priority: Priority.high,
  //           ),
  //         ),
  //         uiLocalNotificationDateInterpretation:
  //             UILocalNotificationDateInterpretation.absoluteTime,
  //       );

  //       // await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       //   event.id!,
  //       //   event.title,
  //       //   event.description,
  //       //   futureScheduledTime,
  //       //   const NotificationDetails(
  //       //     android: AndroidNotificationDetails(
  //       //       'channel_id',
  //       //       'channel_name',
  //       //       channelDescription: 'channel_description',
  //       //       importance: Importance.max,
  //       //       priority: Priority.high,
  //       //     ),
  //       //   ),
  //       //   uiLocalNotificationDateInterpretation:
  //       //       UILocalNotificationDateInterpretation.absoluteTime,
  //       //   matchDateTimeComponents: DateTimeComponents.time,
  //       // );
  //       print('Notification scheduled for event: ${event.title}');
  //     } catch (e) {
  //       print('Error scheduling notification for event ${event.title}: $e');
  //     }
  //   }
  // }

//! showScheduledForEvent

  // static Future showScheduledForEvent(Events event) async {
  //   NotificationDetails details = const NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       "id 2",
  //       "scheduled notification",
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       enableVibration: true,
  //       autoCancel: true,
  //       color: Color(0xFF8A4D1F),
  //       ledColor: Color(0xFF8A4D1F),
  //       ledOnMs: 1000,
  //       ledOffMs: 500,
  //       playSound: true,
  //       fullScreenIntent: true,
  //       visibility: NotificationVisibility.public,
  //     ),
  //   );
  //   tz.initializeTimeZones();
  //   final nowLocal = tz.TZDateTime.now(tz.local);
  //   final eventDate = DateFormat('yyyy-MM-dd').parse(event.date);
  //   final eventTime = event.startTime;
  //   final localScheduledTime = tz.TZDateTime(
  //     tz.local,
  //     eventDate.year,
  //     eventDate.month,
  //     eventDate.day,
  //     eventTime.hour - 3,
  //     eventTime.minute,
  //   );
  //   final futureScheduledTime = localScheduledTime.isBefore(nowLocal)
  //       ? localScheduledTime.add(const Duration(days: 1))
  //       : localScheduledTime;
  //   print('Scheduled Time (Local): ${futureScheduledTime.toIso8601String()}');
  //   print('Current Time (Local): ${nowLocal.toIso8601String()}');

  //   try {
  //     await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       event.id!,
  //       event.title,
  //       event.description,
  //       futureScheduledTime,
  //       details,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       payload: event.type,
  //     );
  //   } catch (e) {
  //     log("error" + e.toString());
  //   }
  // }

  void cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}

class NotificationScreen extends StatefulWidget {
  final String title;
  final String description;

  const NotificationScreen(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 100),
      vsync: this,
    )..repeat();
    final parts = widget.title.split('~');

    final title = parts.isNotEmpty ? parts[0] : 'No Title';
    final description = parts.length > 1 ? parts[1] : 'No Description';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0e090f),
              Color(0xFF242132),
              Color.fromARGB(
                255,
                55,
                50,
                78,
              ),
              Color.fromARGB(
                255,
                46,
                41,
                69,
              ),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              // top: 1,
              // bottom: 1,
              child: AnimatedBuilder(
                animation: _controller,
                child: Image.asset(
                  "assets/images/pngegg6.png",
                  fit: BoxFit.cover,
                  // height: _deviceHeight,
                ),
                builder: (context, child) {
                  return Transform.rotate(
                    angle: sin(_controller.value * 2.0 * pi) * 0.5,
                    child: child,
                  );
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Reminder:  " + title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
