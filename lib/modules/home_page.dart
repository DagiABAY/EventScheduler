import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sample_test_app_for_job/databases/data_base.dart';
import 'package:sample_test_app_for_job/models/event.dart';
import 'package:sample_test_app_for_job/modules/add_event.dart';
import 'package:sample_test_app_for_job/modules/update_event.dart';
import 'package:sample_test_app_for_job/modules/view_event.dart';
import 'package:sample_test_app_for_job/providers/event_provider.dart';
import 'dart:math';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late double _deviceHeight;
  late double _deviceWidth;
  bool _listView = true;
  late DateTime? _selectedDate;
  late EventsProvider provider;


  final List<String> _daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<int> _dates = [];

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  final int _currentYear = DateTime.now().year;
  final int _currentDay = DateTime.now().day;
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  @override
  void initState() {
    super.initState();

    _generateDates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerCurrentDate();
    });
    _setSelectedDate();
    _fetchEvents();
    _controller = AnimationController(
      duration: const Duration(seconds: 100),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateDates() {
    _dates.clear();
    final int daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    for (int i = 1; i <= daysInMonth; i++) {
      _dates.add(i);
    }

    setState(() {});
  }

  void _setSelectedDate() {
    _selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  void _fetchEvents() {
    provider = Provider.of<EventsProvider>(context, listen: false);
    String formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    provider.loadEventsForDate(formattedDate);
  }

  final ScrollController _scrollController = ScrollController();

  void _centerCurrentDate() {
    final int currentIndex = _dates.indexOf(_currentDay);
    const double dateWidth = 100.0;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double desiredOffset =
        (currentIndex * dateWidth) - (screenWidth / 2) + (dateWidth / 2);

    _scrollController.animateTo(
      desiredOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildUI() {
    return Consumer<EventsProvider>(builder: (context, provider, _) {
      DateTime now = DateTime.now();
      int currentYear = now.year;
      int currentMonth = now.month;
      DateTime currentDate = DateTime(currentYear, currentMonth, now.day);
      if (_selectedDate != null) {
        provider
            .loadEventsForDate(DateFormat('yyyy-MM-dd').format(_selectedDate!));
      }
      return Scaffold(
          appBar: AppBar(
            shadowColor: const Color(
              0xFF0e090f,
            ),
            foregroundColor: Colors.white,
            backgroundColor: const Color(
              0xFF0e090f,
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Today's",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Agenda",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddEventScreen(
                        selectedDate:
                            DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      ),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                backgroundColor: const Color.fromARGB(255, 96, 94, 103),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
          ),
          body: Container(
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //   fit: BoxFit.contain,
              //   image: AssetImage("assets/images/pngegg6.png"),
              // ),
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
                SizedBox(
                  height: _deviceHeight * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            DropdownButton<int>(
                              value: _selectedMonth,
                              onChanged: (newMonth) {
                                setState(() {
                                  _selectedMonth = newMonth!;
                                  _generateDates();
                                  _selectedDate = null;
                                  _scrollController.jumpTo(0);
                                  _centerCurrentDate();
                                });
                              },
                              items: List.generate(12, (index) {
                                final month = index + 1;
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text(
                                    DateFormat.MMMM()
                                        .format(DateTime(0, month)),
                                    style: TextStyle(
                                      color: _selectedMonth == month
                                          ? Colors.white
                                          : const Color.fromARGB(255, 8, 2, 23),
                                    ),
                                  ),
                                );
                              }),
                              dropdownColor:
                                  const Color.fromARGB(255, 96, 94, 103),
                              focusColor: const Color(0xff7b7883),
                            ),
                            const SizedBox(width: 16),
                            DropdownButton<int>(
                              value: _selectedYear,
                              onChanged: (newYear) {
                                setState(() {
                                  _selectedYear = newYear!;
                                  _generateDates();
                                  _scrollController.jumpTo(0);
                                  if (_selectedYear == _currentYear) {
                                    _centerCurrentDate();
                                  }
                                  if (_selectedDate == null) {
                                    _selectedDate = currentDate;
                                    _updateDayWithEvents();
                                  } else {
                                    _selectedDate = DateTime(
                                      _selectedYear,
                                      _selectedMonth,
                                    );
                                    _updateDayWithEvents();
                                  }
                                });
                              },
                              items: List.generate(50, (index) {
                                final int year =
                                    DateTime.now().year - 25 + index;
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(
                                    '$year',
                                    style: TextStyle(
                                      color: _selectedYear == year
                                          ? Colors.white
                                          : const Color.fromARGB(255, 8, 2, 23),
                                    ),
                                  ),
                                );
                              }),
                              dropdownColor:
                                  const Color.fromARGB(255, 96, 94, 103),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _circularDateViewer(),
                        _dayWithEvents(provider),
                        _card(provider)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
    });
  }

  Widget _calender() {
    return SfCalendar(
      view: CalendarView.month,
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }

  void _updateDayWithEvents() {
    setState(() {});
  }

  Widget _circularDateViewer() {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    DateTime currentDate = DateTime(currentYear, currentMonth, now.day);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {});
      },
      child: Container(
        height: 100,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            return true;
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Row(
              children: List.generate(_dates.length, (index) {
                final int day = _dates[index];
                final bool isCurrentDate = currentDate.day == day &&
                    currentDate.month == _selectedMonth &&
                    currentDate.year == _selectedYear;
                final bool isSelectedDate = _selectedDate != null &&
                    _selectedDate!.day == day &&
                    _selectedDate!.month == _selectedMonth &&
                    _selectedDate!.year == _selectedYear;

                final containerColor = isSelectedDate
                    ? const Color(0xff7b7883)
                    : (isCurrentDate
                        ? const Color(0xfff0f0f0)
                        : Colors.transparent);

                final textStyle = TextStyle(
                  fontSize: 16,
                  color: isSelectedDate
                      ? Colors.white
                      : (isCurrentDate
                          ? Colors.black
                          : const Color.fromARGB(255, 236, 236, 237)),
                );

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedDate == null) {
                        _selectedDate = currentDate;
                        _updateDayWithEvents();
                      } else {
                        _selectedDate =
                            DateTime(_selectedYear, _selectedMonth, day);
                        _updateDayWithEvents();
                      }
                    });
                  },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _daysOfWeek[(index +
                                        DateTime(_selectedYear, _selectedMonth,
                                                1)
                                            .weekday -
                                        1) %
                                    7],
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$day',
                                style: textStyle,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dayWithEvents(EventsProvider provider) {
    final noEvents = provider.events.length;
    final DateTime now = DateTime.now();
    final DateTime displayDate = _selectedDate ?? now;
    final String formattedDate = DateFormat('EEEE d').format(displayDate);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              Text(
                "$noEvents events",
                style: const TextStyle(color: Color(0xff7b7883)),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade600),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _listView ? const Color(0xff7b7883) : null,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: () {
                      setState(() {
                        _listView = !_listView;
                      });
                    },
                    color: Colors.white,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !_listView ? const Color(0xff7b7883) : null,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                        _listView = !_listView;
                      });
                    },
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(EventsProvider provider) {
    final events = provider.getEvents;
    // final sortedEvents = events
    //   ..sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));
    // print("eeeeeeeeeeeeeeeeeeee " + sortedEvents.length.toString());
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No events for this date',
          style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Color(0xff7b7883)),
        ),
      );
    }
    return _listView
        ? SizedBox(
            height: _deviceHeight * 0.4,
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Event(
                  deviceHeight: _deviceHeight,
                  deviceWidth: _deviceWidth,
                  colors: provider.getGradient(event.id!),
                  title: event.title,
                  provider: provider,
                  event: events[index],
                  description: event.description,
                  startTime: formatTimeOfDay(event.startTime),
                  endTime: formatTimeOfDay(event.endTime),
                  type: event.type,
                );
              },
            ),
          )
        : SizedBox(
            height: _deviceHeight * 0.4,
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final startTime = event.startTime.format(context);
                final endTime = event.endTime.format(context);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          startTime,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // decoration: BoxDecoration(
                          //   gradient: LinearGradient(
                          //     begin: Alignment.bottomLeft,
                          //     end: Alignment.topRight,
                          //     colors: provider.getGradient(event.id!),
                          //   ),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Card(
                            color: const Color.fromARGB(255, 209, 205, 219),
                            margin: EdgeInsets.zero,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event.description,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    endTime,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
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
              },
            ));
  }

  List<Color> _generateRandomColors(
      int numberOfColors, Color startColor, Color endColor) {
    final Random random = Random();
    final List<Color> colors = [];
    for (int i = 0; i < numberOfColors; i++) {
      double t = random.nextDouble();
      Color color = Color.lerp(startColor, endColor, t)!;
      colors.add(color);
    }

    return colors;
  }

  List<List<Color>> generateGradients(int count) {
    final gradients = <List<Color>>[];
    for (int i = 0; i < count; i++) {
      gradients.add(_generateRandomColors(
        3,
        const Color(0xFFd2bb9c),
        const Color(0xFF3c385b),
      ));
    }
    return gradients;
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final formatter = DateFormat.jm();
    return formatter.format(dateTime);
  }
}

class Event extends StatelessWidget {
  const Event({
    super.key,
    required double deviceHeight,
    required double deviceWidth,
    required this.colors,
    required this.provider,
    required this.event,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
  })  : _deviceHeight = deviceHeight,
        _deviceWidth = deviceWidth;

  final double _deviceHeight;
  final double _deviceWidth;
  final List<Color> colors;

  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final EventsProvider provider;
  final Events event;
  final String type;

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewEvent(
              event: event,
            ),
          ),
        );
      },
      child: Container(
        height: _deviceHeight * .20,
        width: _deviceWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 10, 10, 0),
          child: Stack(
            children: [
              Positioned(
                top: 1,
                right: 1,
                child: ElevatedButton(
                  onPressed: () async {
                    print("scheduled");
                    List<Events> events =
                        await DatabaseHelper.instance.getAllEvents();
                    for (Events event in events) {
                      DateTime.parse(event.date).add(Duration(
                          hours: event.startTime.hour,
                          minutes: event.startTime.minute));
                      // await LocalNoti.scheduleNotificationsFromDatabase();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors[2],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    minimumSize: const Size(0, 5),
                  ),
                  child: Text(
                    " $type ",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _title(title),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: const Color.fromARGB(
                                        255, 176, 170, 192),
                                  ),
                            ),
                            Container(
                                constraints: BoxConstraints(
                                  maxWidth: _deviceWidth * 0.8,
                                ),
                                child: Text(
                                  description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            startTime,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "-",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            endTime,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateEvents(
                                    event: event,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      34,
                                      31,
                                      56,
                                    ),
                                    shadowColor: const Color.fromARGB(
                                      255,
                                      143,
                                      143,
                                      142,
                                    ),
                                    title: const Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Icon(
                                        Icons.warning_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                    content: const Text(
                                      'Do you want to delete this event?',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Future.microtask(() {
                                            provider.deleteEvent(event);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}


  // Widget _topBar() {
  //   return Container(
  //     height: _deviceHeight * 0.19,
  //     decoration: BoxDecoration(),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(
  //             20,
  //             30,
  //             0,
  //             0,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.max,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Your today's",
  //                 style: TextStyle(fontSize: 30, color: Colors.white),
  //               ),
  //               Text(
  //                 "Agenda",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 30,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.fromLTRB(
  //             20,
  //             30,
  //             0,
  //             0,
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               FloatingActionButton(
  //                 onPressed: () {},
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(100),
  //                 ),
  //                 backgroundColor: const Color(0xff353140),
  //                 child: const Icon(
  //                   Icons.filter_list,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               const SizedBox(
  //                 width: 3,
  //               ),
  //               FloatingActionButton(
  //                   onPressed: () {},
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(100.0),
  //                   ),
  //                   backgroundColor: const Color(0xff353140),
  //                   child: const Icon(
  //                     Icons.add,
  //                     color: Colors.white,
  //                   ))
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }