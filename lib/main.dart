import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_idol/models/character_deck.dart';
import 'package:guess_idol/screens/pick_character.dart';
import 'package:guess_idol/screens/play.dart';
import 'package:guess_idol/screens/seed_initializer.dart';
import 'package:provider/provider.dart';
import 'package:guess_idol/models/character.dart';
import 'package:guess_idol/ultils/get_gsheet.dart';

void main() {
  runApp(const MainApp());
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SeedInitializer(),
      ),
      GoRoute(
        path: '/pick',
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          return PickCharacter(queryParams: queryParams);
        },
        // stransition: Transition.fadeIn,
      ),
      GoRoute(
        path: '/play',
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          return Play(queryParams: queryParams);
        },
      ),
    ],
  );
}

Future<void> _initializeApp(BuildContext context) async {
  try {
    final characterDeck = Provider.of<CharacterDeck>(context, listen: false);
    final data =
        await getGSheet("1Ls8wM7rnT4ND3lGh2GBIOmh0WjTYC4HU_reZ3rFeS7g", "0");

    for (var json in data) {
      characterDeck.add(Character.fromJson(json));
    }
  } catch (e) {
    print('Error initializing app: $e');
    rethrow;
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CharacterDeck>(
          create: (context) => CharacterDeck(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Guess Idol',
        debugShowCheckedModeBanner: false,
        routerConfig: router(),
        builder: (context, child) => FutureBuilder(
          future: _initializeApp(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return child!;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
