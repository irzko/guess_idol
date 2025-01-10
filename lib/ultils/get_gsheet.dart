// import 'dart:developer';

import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Map<String, String>>> getGSheet(
    String spreadsheetId, String sheetId) async {
  final response = await http.get(Uri.parse(
      'https://docs.google.com/spreadsheets/d/${spreadsheetId}/export?format=csv&id=${spreadsheetId}&gid=${sheetId}'));

  if (response.statusCode != 200) {
    throw Exception("Failed to load data from Google Sheet");
  }

  final data = utf8.decode(response.body.codeUnits);

  final rows = data.split("\n").map((row) => row.split(",")).toList();
  final header = rows.first;
  final rowsWithoutHeader = rows.skip(1).toList();
  final dataWithHeader = rowsWithoutHeader.map((row) {
    final Map<String, String> rowData = {};
    for (var i = 0; i < row.length; i++) {
      rowData[header[i].trim()] = row[i].trim();
    }
    return rowData;
  }).toList();

  return dataWithHeader;
}
