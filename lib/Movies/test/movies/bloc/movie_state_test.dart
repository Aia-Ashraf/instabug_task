// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_task/Movies/bloc/movie_state.dart';

void main() {
  group('MovieState', () {
    test('supports value comparison', () {
      expect(MovieState(), MovieState());
      expect(
        MovieState().toString(),
        MovieState().toString(),
      );
    });
  });
}
