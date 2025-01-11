import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:guess_idol/models/character.dart';

class CharacterDeck extends ChangeNotifier {
  final List<Character> _characters = [];

  UnmodifiableListView<Character> get characters =>
      UnmodifiableListView(_characters);

  void add(Character character) {
    _characters.add(character);
    notifyListeners();
  }

  Character? findCharacterById(String id) {
    return _characters.firstWhere((element) => element.id == id);
  }
}
