import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instabug_task/simple_bloc_observer.dart';

import 'app.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(const App());
}
