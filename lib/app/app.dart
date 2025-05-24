// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../application/bloc/album_bloc.dart';
import '../application/bloc/album_event.dart'; // Add this import
import '../data/repositories/album_repository_impl.dart';
import '../data/data_sources/album_remote_data_source.dart';
import '../core/network/http_client.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumBloc(
        repository: AlbumRepositoryImpl(
          remoteDataSource: AlbumRemoteDataSource(
            httpClient: CustomHttpClient(),
          ),
        ),
      )..add(FetchAlbumsEvent()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Album Explorer',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.grey[900],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardTheme(
            color: Colors.grey[800],
            elevation: 4,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}