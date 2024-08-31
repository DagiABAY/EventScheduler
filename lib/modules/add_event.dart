import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample_test_app_for_job/models/event.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sample_test_app_for_job/providers/event_provider.dart';

class AddEventScreen extends StatefulWidget {
  // final Event? event;
  final String selectedDate;
  const AddEventScreen({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  AddEventScreenState createState() => AddEventScreenState();
}

List<CoolDropdownItem<String>> dropdownItemList = [];
List<String> eventType = [
  'Work',
  'Personal',
  'Meeting',
  'Others',
];

class AddEventScreenState extends State<AddEventScreen> {
  List<CoolDropdownItem<String>> eventTypeDropdownItems = [];

  final eventTypeDropdownController = DropdownController<String>();

  final _formKey = GlobalKey<FormState>();
  late DateTime _startTime;
  late DateTime _endTime;
  late String _type;

  late String type;
  List<String> _imagePaths = [];

  final _types = ['Work', 'Personal', 'Meeting', 'Others'];

  @override
  void initState() {
    for (var i = 0; i < eventType.length; i++) {
      eventTypeDropdownItems.add(CoolDropdownItem<String>(
          label: ' ${eventType[i]}',
          icon: Container(
            margin: const EdgeInsets.only(left: 10),
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              'assets/svg/${eventType[i]}.svg',
            ),
          ),
          selectedIcon: Container(
            margin: const EdgeInsets.only(left: 10),
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              'assets/${eventType[i]}.svg',
              color: const Color(0xFF6FCC76),
            ),
          ),
          value: '${eventType[i]}'));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final initialTime = isStartTime
        ? TimeOfDay.fromDateTime(_startTime)
        : TimeOfDay.fromDateTime(_endTime);

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      final pickedDateTime = DateTime(
        _startTime.year,
        _startTime.month,
        _startTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        if (isStartTime) {
          _startTime = pickedDateTime;
        } else {
          _endTime = pickedDateTime;
        }
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
      });
    }
  }

  TimeOfDay startTime = const TimeOfDay(hour: 6, minute: 00);
  TimeOfDay endTime = const TimeOfDay(
    hour: 8,
    minute: 00,
  );
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, provider, _) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shadowColor: const Color(0xFF0e090f),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0e090f),
          title: const Text('Add Event'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                _saveEvent(provider);
              },
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage("assets/images/pngegg12.png"),
            ),
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
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: provider.titleEdditnigController,
                      cursorColor: Colors.white,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white),
                        hoverColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: provider.descriptionEdditngController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Description",
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField<String>(
                      value: _types.first,
                      items: _types.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Type',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 96, 94, 103),
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 96, 94, 103),
                              width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 96, 94, 103),
                              width: 1.5),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      dropdownColor: const Color.fromARGB(255, 96, 94, 103),
                      iconEnabledColor: const Color.fromARGB(255, 96, 94, 103),
                      iconSize: 30.0,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
//!.......................................................

                    // WillPopScope(
                    //   onWillPop: () async {
                    //     if (eventTypeDropdownController.isOpen) {
                    //       eventTypeDropdownController.close();
                    //       return Future.value(false);
                    //     } else {
                    //       return Future.value(true);
                    //     }
                    //   },
                    //   child: CoolDropdown<String>(
                    //     controller: eventTypeDropdownController,
                    //     dropdownList: eventTypeDropdownItems,
                    //     defaultItem: eventTypeDropdownItems.first,
                    //     onChange: (value) async {
                    //       if (eventTypeDropdownController.isError) {
                    //         await eventTypeDropdownController.resetError();
                    //       }
                    //       setState(() {
                    //         type = value;
                    //       });
                    //     },
                    //     onOpen: (value) {},
                    //     resultOptions: const ResultOptions(
                    //       padding: EdgeInsets.symmetric(horizontal: 10),
                    //       width: 200,
                    //       icon: SizedBox(
                    //         width: 10,
                    //         height: 10,
                    //         child: CustomPaint(
                    //           painter: DropdownArrowPainter(),
                    //         ),
                    //       ),
                    //       render: ResultRender.all,
                    //       placeholder: 'Select Type',
                    //       isMarquee: true,
                    //     ),
                    //     dropdownOptions: const DropdownOptions(
                    //         top: 20,
                    //         height: 250,
                    //         gap: DropdownGap.all(5),
                    //         color: Color.fromARGB(255, 96, 94, 103),
                    //         borderSide:
                    //             BorderSide(width: 1, color: Colors.white),
                    //         padding: EdgeInsets.symmetric(horizontal: 10),
                    //         align: DropdownAlign.left,
                    //         animationType: DropdownAnimationType.size),
                    //     dropdownTriangleOptions: const DropdownTriangleOptions(
                    //       width: 20,
                    //       height: 30,
                    //       align: DropdownTriangleAlign.left,
                    //       borderRadius: 3,
                    //       left: 20,
                    //     ),
                    //     dropdownItemOptions: const DropdownItemOptions(
                    //       isMarquee: true,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       render: DropdownItemRender.all,
                    //       height: 50,
                    //     ),
                    //   ),
                    // ),

                    //! /////////////////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Start time: ${startTime.format(context)}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _selectTimes(startTime),
                          style: const ButtonStyle(
                              iconColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              iconSize: WidgetStatePropertyAll(40)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'End time: ${endTime.format(context)}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.access_time,
                          ),
                          onPressed: () => _selectTimes(endTime),
                          style: const ButtonStyle(
                              iconColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              iconSize: WidgetStatePropertyAll(40)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _saveEvent(provider);
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              color: Color.fromARGB(255, 96, 94, 103)),
                        ))
                  ],
                )),
          ),
        ),
      );
    });
  }

  void _selectTimes(TimeOfDay time) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (newTime != null && time == startTime) {
      setState(() {
        startTime = newTime;
      });
    }
    if (newTime != null && time == endTime) {
      setState(() {
        endTime = newTime;
      });
    }
  }

  void _saveEvent(EventsProvider provider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final event = Events(
        title: provider.titleEdditnigController.text.toString(),
        description: provider.descriptionEdditngController.text.toString(),
        startTime: startTime,
        endTime: endTime,
        type: _type,
        date: widget.selectedDate,
      );

      provider.addEvent(event);
      provider.descriptionEdditngController.clear();
      provider.titleEdditnigController.clear();
    }

    Navigator.of(context).pop();
  }

  Future<PlatformFile?> pickImageFromLibrary() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return result.files[0];
    }
    return null;
  }
}
