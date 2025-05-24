// lib/application/bloc/album_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/album.dart';
import '../../domain/entities/album_with_photos.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object?> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;

  const AlbumLoaded({required this.albums});

  @override
  List<Object?> get props => [albums];
}

class AlbumsWithPhotosLoaded extends AlbumState {
  final List<AlbumWithPhotos> albumsWithPhotos;

  const AlbumsWithPhotosLoaded({required this.albumsWithPhotos});

  @override
  List<Object?> get props => [albumsWithPhotos];
}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError(this.message);

  @override
  List<Object?> get props => [message];
}