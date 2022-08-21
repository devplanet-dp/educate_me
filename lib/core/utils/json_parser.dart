import 'dart:convert';
import 'dart:isolate';

class SearchResultsParser {
  // 1. pass the encoded json as a constructor argument
  SearchResultsParser(
    this.encodedJson,
    this.make,
  );

  final String encodedJson;
  final String? make;

  // 2. public method that does the parsing in the background
  Future<List<String>> parseInBackground() async {
    // create a port
    final p = ReceivePort();
    // spawn the isolate and wait for it to complete
    await Isolate.spawn(
        make == null ? _decodeAndParseJson : _decodeAndParsModels, p.sendPort);
    // get and return the result data
    return await p.first;
  }

  // 3. json parsing
  Future<void> _decodeAndParseJson(SendPort p) async {
    // decode and parse the json
    final jsonData = jsonDecode(encodedJson);
    final resultsJson = jsonData as List<dynamic>;
    List<String> list = [];
    for (var e in resultsJson) {
      if (!list.contains(e['Make'])) {
        list.add(e['Make']);
      }
    }
    Isolate.exit(p, list);
  }

  Future<void> _decodeAndParsModels(SendPort p) async {
    // decode and parse the json
    final jsonData = jsonDecode(encodedJson);
    final resultsJson = jsonData as List<dynamic>;
    List<String> list = [];
    for (var e in resultsJson) {
      if (e['Make'] == make) {
        list.add(e['Model']);
      }
    }
    Isolate.exit(p, list);
  }
}
