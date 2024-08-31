import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback callback;
  const SplashPage({super.key, required this.callback});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then(
      (_) => widget.callback(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DaSchedule",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: Colors.white,
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
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/pngegg3.png"),
              )),
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "Developed by: DagiABAY@github.com",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
