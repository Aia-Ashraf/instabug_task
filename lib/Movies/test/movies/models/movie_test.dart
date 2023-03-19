// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_task/Movies/domain/models/models.dart';

void main() {
  group('Movie', () {
    test('supports value comparison', () {
      expect(
        MovieItem(id: 1, title: 'movie title'),
        MovieItem(id: 1, title: 'movie title'),
      );
    });
  });
}
