import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/album_with_photos.dart';
import 'album_event.dart';
import 'album_state.dart';
import '../../domain/repositories/album_repository.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository repository;

  AlbumBloc({required this.repository}) : super(AlbumInitial()) {
    on<FetchAlbumsEvent>(_onFetchAlbums);
    on<FetchAlbumsWithPhotosEvent>(_onFetchAlbumsWithPhotos);
  }

  Future<void> _onFetchAlbums(
      FetchAlbumsEvent event,
      Emitter<AlbumState> emit,
      ) async {
    emit(AlbumLoading());
    try {
      final albums = await repository.getAlbums();
      emit(AlbumLoaded(albums: albums));
    } catch (e) {
      emit(AlbumError('Failed to fetch albums: ${e.toString()}'));
    }
  }

  Future<void> _onFetchAlbumsWithPhotos(
      FetchAlbumsWithPhotosEvent event,
      Emitter<AlbumState> emit,
      ) async {
    emit(AlbumLoading());
    try {
      final albums = await repository.getAlbums();
      final albumsWithPhotos = await Future.wait(
        albums.map((album) async {
          final photos = await repository.getPhotosForAlbum(album.id);
          return AlbumWithPhotos(album: album, photos: photos);
        }),
      );
      emit(AlbumsWithPhotosLoaded(albumsWithPhotos: albumsWithPhotos));
    } catch (e) {
      emit(AlbumError('Failed to fetch albums with photos: ${e.toString()}'));
    }
  }
}