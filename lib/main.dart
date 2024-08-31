import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sample_test_app_for_job/databases/data_base.dart';
import 'package:sample_test_app_for_job/models/event.dart';
import 'package:sample_test_app_for_job/modules/home_page.dart';
import 'package:sample_test_app_for_job/modules/splashe_page.dart';
import 'package:sample_test_app_for_job/providers/event_provider.dart';
import 'package:sample_test_app_for_job/providers/local_notification.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> requestNotificationPermission() async {
  try {
    Map<Permission, PermissionStatus> status = await [
      Permission.notification,
    ].request();

    if (status[Permission.notification]!.isDenied) {
      // Handle the case where the permission is denied
      print('Notification permission denied');
    }
  } catch (e) {
    print('Error requesting notification permission: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotificationPermission();
  tz.initializeTimeZones();
  await LocalNoti.initNoti();

  runApp(SplashPage(
    callback: () => runApp(
      ChangeNotifierProvider(
        create: (context) => EventsProvider(),
        child: const MyApp(),
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Sample Schedule App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
//  Scaffold(
        //   body: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         ElevatedButton(
        //             onPressed: ()async {
        //              await LocalNoti.showSimpleNoti();
        //             },
        //             child: Text(
        //               "Simple Notification",
        //             )),
        //             ElevatedButton(
        //             onPressed: ()async {
        //              await LocalNoti.showScheduled();
        //             },
        //             child: Text(
        //               "scheduled Notification",
        //             ))
        //       ],
        //     ),
        //   ),
        // ),