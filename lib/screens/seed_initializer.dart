import 'package:flutter/material.dart';
import 'package:guess_idol/components/seed_form.dart';

class SeedInitializer extends StatelessWidget {
  const SeedInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: SeedForm()),
    );
  }
}
