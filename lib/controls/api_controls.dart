
import 'package:big_movie_app/controls/api_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiControls implements ApiRepository {
  final String baseUrl = dotenv.env['API_ENDPOINT'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String apiReadAccessToken = dotenv.env['API_READ_ACCESS_TOKEN'] ?? '';

  @override
  Future<Response> fetchPopularMovies({int page = 1}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiReadAccessToken',
    };

    Map<String, String> queryParams = {
      'page': '$page',
    };

    Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: headers);

    return response;
  }
}
