// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';

import '../../app.dart';
import '../presentation/view/movies_page.dart';

void main() {
  group('App', () {
    testWidgets('renders MoviesPage', (tester) async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
      expect(find.byType(MoviesPage), findsOneWidget);
    });
  });
}
