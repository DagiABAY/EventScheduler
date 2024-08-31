
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_test_app_for_job/models/event.dart';
import 'package:sample_test_app_for_job/providers/event_provider.dart';

class ViewEvent extends StatefulWidget {
  final Events event;
  const ViewEvent({super.key, required this.event});

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 55, 50, 78),
        appBar: AppBar(
          shadowColor: const Color(0xFF0e090f),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0e090f),
          title: const Text('View Event'),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
                // top: 1,
                // bottom: 1,
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/pngegg5.png"),
                      ),
                    ))),
            Transform.rotate(
              angle: 0.3,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0e090f),
                        Color(0xFF242132),
                        Color.fromARGB(255, 55, 50, 78),
                        Color.fromARGB(255, 46, 41, 69),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.event.title,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.event.description,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTimeRow(Icons.access_time,
                            'Start time: ${widget.event.startTime.format(context)}'),
                        const SizedBox(height: 10),
                        _buildTimeRow(Icons.access_time,
                            'End time: ${widget.event.endTime.format(context)}'),
                        const Spacer(),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTimeRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
