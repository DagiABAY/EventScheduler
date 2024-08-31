import 'package:flutter/material.dart';
import 'package:sample_test_app_for_job/not.dart';

class MyHomePages extends StatefulWidget {
  const MyHomePages({super.key, required this.title});

  final String title;

  @override
  State<MyHomePages> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ScheduleBtn(),
          ],
        ),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for 1 minute from now');
        NotificationService().scheduleNotification(
          title: 'Scheduled Notification',
          body: 'This notification is scheduled for 1 minute from now',
        );
      },
    );
  }
}
