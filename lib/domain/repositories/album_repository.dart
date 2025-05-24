import '../entities/album.dart';
import '../entities/photo.dart';

abstract class AlbumRepository {
  Future<List<Album>> getAlbums();
  Future<List<Photo>> getPhotosForAlbum(int albumId);
}