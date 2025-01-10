import 'package:flutter/material.dart';
import 'package:guess_idol/models/character.dart';
import 'package:guess_idol/ultils/create_sheet_character.dart';
import 'package:guess_idol/ultils/get_gsheet.dart';
import 'dart:async';

class PickCharacterScreen extends StatelessWidget {
  const PickCharacterScreen({super.key, required this.seed});

  final String seed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pick Character'),
        ),
        body: Center(
          child: Container(
              constraints: BoxConstraints(maxWidth: 640),
              child: CharacterDeck(seed: seed)),
        ));
  }
}

Future<List<Character>> loadCharacters(int seed) async {
  final data =
      await getGSheet("1Ls8wM7rnT4ND3lGh2GBIOmh0WjTYC4HU_reZ3rFeS7g", "0");
  var characters = data.map((json) => Character.fromJson(json)).toList();
  return createSheetCharacter(characters, 25, seed);
}

class CharacterDeck extends StatefulWidget {
  const CharacterDeck({
    super.key,
    required this.seed,
  });

  final String seed;

  @override
  State<CharacterDeck> createState() => _CharacterDeckState();
}

class _CharacterDeckState extends State<CharacterDeck> {
  late Future<List<Character>> characters;

  @override
  void initState() {
    super.initState();
    characters = loadCharacters(int.parse(widget.seed));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: characters,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              childAspectRatio: 10 / 16,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                // elevation: 4,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.network(
                        snapshot.data![index].image,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                        // width: double.infinity,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          snapshot.data![index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              ;
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
