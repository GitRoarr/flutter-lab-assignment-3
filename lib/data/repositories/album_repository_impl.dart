import '../../domain/entities/album.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/album_repository.dart';
import '../data_sources/album_remote_data_source.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumRemoteDataSource remoteDataSource;

  AlbumRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Album>> getAlbums() async {
    try {
      final albumModels = await remoteDataSource.fetchAlbums();
      return albumModels.map((model) => Album(
        userId: model.userId,
        id: model.id,
        title: model.title,
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }

  Future<List<Photo>> getPhotos() async {
    try {
      final photoModels = await remoteDataSource.fetchPhotos();
      return photoModels.map((model) => Photo(
        albumId: model.albumId,
        id: model.id,
        title: model.title,
        url: model.url,
        thumbnailUrl: model.thumbnailUrl,
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch photos: $e');
    }
  }

  @override
  Future<List<Photo>> getPhotosForAlbum(int albumId) async {
    try {
      final allPhotos = await getPhotos();
      return allPhotos.where((photo) => photo.albumId == albumId).toList();


    } catch (e) {
      throw Exception('Failed to fetch photos for album $albumId: $e');
    }
  }
}