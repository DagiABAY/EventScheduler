import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_test_app_for_job/models/event.dart';
import 'package:sample_test_app_for_job/providers/event_provider.dart';

class UpdateEvents extends StatefulWidget {
  final Events? event;
  const UpdateEvents({super.key, this.event});

  @override
  State<UpdateEvents> createState() => _UpdateEventsState();
}

class _UpdateEventsState extends State<UpdateEvents> {
  final _formKey = GlobalKey<FormState>();
  final _types = ['Work', 'Personal', 'Meeting', 'Others'];

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  String? _type;
  String? date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.event?.description ?? '');
    startTime = widget.event?.startTime ?? TimeOfDay.now();
    endTime = widget.event?.endTime ?? TimeOfDay.now();
    _type = widget.event?.type ?? _types.first;
    date = widget.event?.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          shadowColor: const Color(0xFF0e090f),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0e090f),
          title: const Text('Update Event'),
          actions: [
            IconButton(
              icon: const Icon(Icons.upgrade),
              onPressed: () {
                _updateEvents(provider);
              },
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: _titleController,
                    cursorColor: Colors.white,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _type,
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
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 96, 94, 103),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 96, 94, 103),
                          width: 1.5,
                        ),
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
                  const SizedBox(height: 16),
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
                        onPressed: () => _selectTimes(isStart: true),
                        // style: const ButtonStyle(
                        //   iconColor: MaterialStateProperty.all(Colors.white),
                        //   iconSize: MaterialStateProperty.all(40),
                        // ),
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
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTimes(isStart: false),
                        // style: const ButtonStyle(
                        //   iconColor: MaterialStateProperty.all(Colors.white),
                        //   iconSize: MaterialStateProperty.all(40),
                        // ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _updateEvents(provider),
                    child: const Text(
                      "Update",
                      style: TextStyle(
                        color: Color.fromARGB(255, 96, 94, 103),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _selectTimes({required bool isStart}) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (newTime != null) {
      setState(() {
        if (isStart) {
          startTime = newTime;
        } else {
          endTime = newTime;
        }
      });
    }
  }

  void _updateEvents(EventsProvider provider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final event = Events(
        id: widget.event?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        startTime: startTime,
        endTime: endTime,
        type: _type!,
        date: date!,
      );

      provider.updateEvent(event);
      Navigator.of(context).pop();
    }
  }
}
