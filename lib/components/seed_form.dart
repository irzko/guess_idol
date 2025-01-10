// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:guess_idol/screens/pick_character_screen.dart';

class SeedForm extends StatefulWidget {
  const SeedForm({super.key});

  @override
  State<SeedForm> createState() => _SeedFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SeedFormState extends State<SeedForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Guess Idol',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: myController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your name',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PickCharacterScreen(seed: myController.text),
                ),
              );
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}
