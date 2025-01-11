// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SeedForm extends StatefulWidget {
  const SeedForm({super.key});

  @override
  State<SeedForm> createState() => _SeedFormState();
}

class _SeedFormState extends State<SeedForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
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
                context.go(
                    Uri(path: '/pick', queryParameters: {'seed': myController.text})
                        .toString());
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
