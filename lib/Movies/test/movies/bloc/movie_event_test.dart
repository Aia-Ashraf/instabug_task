// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_task/Movies/bloc/movie_event.dart';

void main() {
  group('MovieEvent', () {
    group('MovieFetched', () {
      test('supports value comparison', () {
        expect(MovieFetched(), MovieFetched());
      });
    });
  });
}
