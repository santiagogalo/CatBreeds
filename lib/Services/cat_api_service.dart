import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:catbreeds/Models/cat_model.dart';

class CatApiService {
  final String baseUrl = 'https://api.thecatapi.com/v1';
  final String apiKey =
      'live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr';

  final _catStreamController = StreamController<List<Cat>>.broadcast();
  final List<Cat> _cats = [];

  Stream<List<Cat>> get catsStream => _catStreamController.stream;

  Future<void> fetchCats() async {
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(Uri.parse('$baseUrl/breeds'));
    request.headers.set('x-api-key', apiKey);

    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      List jsonResponse = json.decode(responseBody);

      for (var data in jsonResponse) {
        Cat cat = Cat.fromJson(data);
        cat.imageUrl = await getImageUrl(cat.referenceImageId);
        _cats.add(cat);
        _catStreamController.add(
          List.from(_cats),
        ); // Emitir la lista actualizada
      }
    } else {
      throw Exception(
        'Error al cargar las razas de gatos: ${response.statusCode}',
      );
    }
  }

  Future<String?> getImageUrl(String imageId) async {
    if (imageId.isEmpty) return null;

    final httpClient = HttpClient();
    final request = await httpClient.getUrl(
      Uri.parse('$baseUrl/images/$imageId'),
    );
    request.headers.set('x-api-key', apiKey);

    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      return jsonResponse['url'];
    } else {
      return null;
    }
  }

  void dispose() {
    _catStreamController.close();
  }
}
