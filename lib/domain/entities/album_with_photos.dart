import 'package:equatable/equatable.dart';
import 'album.dart';
import 'photo.dart';

class AlbumWithPhotos extends Equatable {
  final Album album;
  final List<Photo> photos;

  const AlbumWithPhotos({
    required this.album,
    required this.photos,
  });

  @override
  List<Object?> get props => [album, photos];
}