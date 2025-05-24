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
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Albums', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF121212),
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
                    Text(state.message, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954),
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.go('/album_detail', extra: {'album': album, 'photos': photos});
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                album.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${photos.length} photos',
                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
