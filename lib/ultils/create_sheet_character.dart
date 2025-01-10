import 'dart:math';
import 'package:guess_idol/models/character.dart';

List<Character> createSheetCharacter(
    List<Character> list, int number, int seed) {
  var random = Random(seed);
  var shuffled = [...list];
  shuffled.shuffle(random);
  return shuffled.sublist(0, number);
}
