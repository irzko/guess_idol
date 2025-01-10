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
      child: Container(
        constraints: BoxConstraints(maxWidth: 640),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16.0,
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
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      borderSide: BorderSide.none),
                  hintText: 'Enter your name',
                  filled: true),
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
      ),
    );
  }
}
