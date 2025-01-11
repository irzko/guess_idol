import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_idol/models/character.dart';
import 'package:guess_idol/models/character_deck.dart';
import 'package:guess_idol/ultils/create_sheet_character.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class Play extends StatelessWidget {
  final Map<String, String> queryParams;
  const Play({super.key, required this.queryParams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.replace(
              Uri(path: '/pick', queryParameters: {
                'seed': queryParams['seed']!,
              }).toString(),
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 640),
          child: CharacterSelector(
              seed: queryParams['seed']!,
              characterId: queryParams['character']!),
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
    required this.characterId,
  });

  final String seed;
  final String characterId;

  @override
  State<CharacterSelector> createState() => _CharacterSelectorState();
}

class _CharacterSelectorState extends State<CharacterSelector> {
  @override
  Widget build(BuildContext context) {
    final characters = loadCharacters(context, int.parse(widget.seed));

    final selectedCharacter =
        context.read<CharacterDeck>().findCharacterById(widget.characterId);

    // list withouth selected character
    final charactersWithoutSelectedCharacter = characters.then((value) {
      return value
          .where((element) => element.id != widget.characterId)
          .toList();
    });

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            width: 10 * 20,
            height: 16 * 20,
            child: Card(
              // elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 3.0 / 4.0,
                    child: Hero(
                      tag: selectedCharacter!.id,
                      child: Image.network(
                        selectedCharacter.image,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                        // width: double.infinity,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        selectedCharacter.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Character>>(
            future: charactersWithoutSelectedCharacter,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.0,
                    childAspectRatio: 10.0 / 16.0,
                    mainAxisSpacing: 2.0,
                  ),
                  padding: const EdgeInsets.all(2.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      // elevation: 4,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 3.0 / 4.0,
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
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
