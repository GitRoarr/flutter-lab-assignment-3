// lib/app/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ presentation/screens/album_list_screen.dart';
import '../ presentation/screens/album_detail_screen.dart';
import '../domain/entities/album.dart';
import '../domain/entities/photo.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'albumList',
      builder: (BuildContext context, GoRouterState state) {
        return const AlbumListScreen();
      },
      routes: [
        GoRoute(
          path: 'album_detail',
          name: 'albumDetail',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;
            final album = extra['album'] as Album;
            final photos = extra['photos'] as List<Photo>;
            return AlbumDetailScreen(album: album, photos: photos);
          },
        ),
      ],
    ),
  ],
);