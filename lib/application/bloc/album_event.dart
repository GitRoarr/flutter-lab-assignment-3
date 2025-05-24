// lib/application/bloc/album_event.dart
import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

class FetchAlbumsEvent extends AlbumEvent {}

class FetchAlbumsWithPhotosEvent extends AlbumEvent {}

class SearchAlbumsEvent extends AlbumEvent {
  final String query;

  const SearchAlbumsEvent(this.query);

  @override
  List<Object?> get props => [query];
}