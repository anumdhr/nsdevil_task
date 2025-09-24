import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final ThemeMode mode;
  ThemeState(this.mode);
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(ThemeMode.system));

  void setLight() => emit(ThemeState(ThemeMode.light));
  void setDark() => emit(ThemeState(ThemeMode.dark));
  void setSystem() => emit(ThemeState(ThemeMode.system));
  void toggle() => state.mode == ThemeMode.dark ? setLight() : setDark();
}
