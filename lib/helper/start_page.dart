import 'package:flutter/material.dart';
import '../modules/home_page.dart'; // Import your HomePage

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Please read below',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF242132),
      ),
      body: Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thank you for considering my request for this project. I completed the Home Page UI within half a day, adhering to the requirement to focus on the front-end only, so some buttons are currently inactive. I hope this demonstrates my skills and dedication. Please click 'Continue' to explore the Home Page and see the work I've done.",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Key Features:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:  Color.fromARGB(255, 96, 94, 103),
                  ),
                ),
                const SizedBox(height: 10),
                _featureDescription(
                  Icons.title,
                  'App Bar',
                  'Displays the page title "Your Today\'s Agenda." Includes two floating action buttons (Filter and Add) which are visible but currently inactive.',
                ),
                _featureDescription(
                  Icons.calendar_today,
                  'Dynamic Calendar View',
                  'Swipe horizontally to view different days of the week and their dates. Functional scrolling through dates; updating event details based on selected dates is yet to be implemented.',
                ),
                _featureDescription(
                  Icons.event,
                  'Event Management',
                  'Shows a list of events for the selected day in a card format. Static event cards are displayed with sample data; dynamic updates and interactions are pending.',
                ),
                _featureDescription(
                  Icons.add_box,
                  'Interactive Elements',
                  'Floating action buttons for filtering and adding tasks. Buttons are present but not yet functional.',
                ),
                _featureDescription(
                  Icons.color_lens,
                  'Design',
                  'Features a dark gradient background and stylish event cards for a modern look. Fully implemented design for a visually appealing interface.',
                ),
                _featureDescription(
                  Icons.phone,
                  'Contact me',
                  'If you are interested in my work, please call me at +251927737621, Email: dagimawulachew@gmail.com',
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 96, 94, 103),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureDescription(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$title:\n',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 96, 94, 103)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
