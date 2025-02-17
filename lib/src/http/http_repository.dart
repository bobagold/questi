import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'http_repository.g.dart';

@Riverpod(keepAlive: true)
Client httpRepository(Ref ref) {
  final client = Client();
  ref.onDispose(client.close);
  return client;
}
