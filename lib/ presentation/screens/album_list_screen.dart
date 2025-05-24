import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/bloc/album_bloc.dart';
import '../../application/bloc/album_event.dart';
import '../../application/bloc/album_state.dart';
import '../../core/network/http_client.dart';
import '../../data/data_sources/album_remote_data_source.dart';
import '../../data/repositories/album_repository_impl.dart';
import '../../domain/entities/album.dart';
import '../../domain/entities/photo.dart';
import '../../core/widgets/loading_widget.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumBloc(
        repository: AlbumRepositoryImpl(
          remoteDataSource: AlbumRemoteDataSource(
            httpClient: CustomHttpClient(),
          ),
        ),
      )..add(FetchAlbumsWithPhotosEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Albums'),
          backgroundColor: const Color(0xFF1DB954), // Spotify green
        ),
        body: BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state) {
            if (state is AlbumLoading) {
              return const LoadingWidget();
            } else if (state is AlbumsWithPhotosLoaded) {
              return ListView.builder(
                itemCount: state.albumsWithPhotos.length,
                itemBuilder: (context, index) {
                  final albumWithPhotos = state.albumsWithPhotos[index];
                  return _AlbumListItem(
                    album: albumWithPhotos.album,
                    photos: albumWithPhotos.photos,
                  );
                },
              );
            } else if (state is AlbumError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954), // Spotify green
                      ),
                      onPressed: () {
                        context.read<AlbumBloc>().add(FetchAlbumsWithPhotosEvent());
                      },
                      child: const Text('Retry', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _AlbumListItem extends StatelessWidget {
  final Album album;
  final List<Photo> photos;

  const _AlbumListItem({
    required this.album,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[900],
      child: InkWell(
        onTap: () {
          context.go('/album_detail', extra: {'album': album, 'photos': photos});
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                album.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              if (photos.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: photos.take(5).length,
                    itemBuilder: (context, index) {
                      final photo = photos[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photo.thumbnailUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[800],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: const Color(0xFF1DB954),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[800],
                                  child: const Center(
                                    child: Icon(Icons.error, color: Colors.white),
                                  ),
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                '${photos.length} photos',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}