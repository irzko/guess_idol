import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_idol/models/character.dart';
import 'package:guess_idol/models/character_deck.dart';
import 'package:guess_idol/ultils/create_sheet_character.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class PickCharacter extends StatelessWidget {
  final Map<String, String> queryParams;
  const PickCharacter({super.key, required this.queryParams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn nhân vật'),
        // back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/");
          },
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 640),
          child: CharacterSelector(seed: queryParams['seed'] ?? '0'),
        ),
      ),
    );
  }
}

Future<List<Character>> loadCharacters(BuildContext context, int seed) async {
  var characters = context.watch<CharacterDeck>();
  return createSheetCharacter(characters.characters, 25, seed);
}

class CharacterSelector extends StatefulWidget {
  const CharacterSelector({
    super.key,
    required this.seed,
  });

  final String seed;

  @override
  State<CharacterSelector> createState() => _CharacterSelectorState();
}

class _CharacterSelectorState extends State<CharacterSelector> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final characters = loadCharacters(context, int.parse(widget.seed));
    return FutureBuilder<List<Character>>(
      future: characters,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.0,
              childAspectRatio: 10.0 / 16.0,
              mainAxisSpacing: 2.0,
            ),
            padding: const EdgeInsets.all(4.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.replace(
                    Uri(path: '/play', queryParameters: {
                      'seed': widget.seed,
                      'character': snapshot.data![index].id,
                    }).toString(),
                  );
                },
                child: Card(
                  // elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 3.0 / 4.0,
                        child: Hero(
                          tag: snapshot.data![index].id,
                          child: Image.network(
                            snapshot.data![index].image,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          ),
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
                ),
              );
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
