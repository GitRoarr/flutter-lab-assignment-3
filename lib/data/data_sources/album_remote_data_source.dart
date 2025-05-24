import '../../core/network/http_client.dart';
import '../models/album_model.dart';
import '../models/photo_model.dart';

class AlbumRemoteDataSource {
  final CustomHttpClient httpClient;

  AlbumRemoteDataSource({required this.httpClient});

  Future<List<AlbumModel>> fetchAlbums() async {
    try {
      final dynamic response = await httpClient.get('https://jsonplaceholder.typicode.com/albums');

      if (response is List) {
        return response.map((json) => AlbumModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format: Expected List but got ${response.runtimeType}');
      }
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }

  Future<List<PhotoModel>> fetchPhotos() async {
    try {
      final dynamic response = await httpClient.get('https://jsonplaceholder.typicode.com/photos');

      if (response is List) {
        return response.map((json) => PhotoModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format: Expected List but got ${response.runtimeType}');
      }
    } catch (e) {
      throw Exception('Failed to fetch photos: $e');
    }
  }
}