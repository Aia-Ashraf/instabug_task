// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../presentation/view/movies_list.dart';
import '../../../presentation/view/movies_page.dart';

void main() {
  group('MoviesPage', () {
    testWidgets('renders MovieList', (tester) async {
      await tester.pumpWidget(MaterialApp(home: MoviesPage()));
      await tester.pumpAndSettle();
      expect(find.byType(MoviesList), findsOneWidget);
    });
  });
}
