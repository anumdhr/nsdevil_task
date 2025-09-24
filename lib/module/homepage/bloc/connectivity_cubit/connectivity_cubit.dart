import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/utils/connectiviity.dart';

@immutable
abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {}

class ConnectivityDisconnected extends ConnectivityState {}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final InternetConnectivitySingleton _connectivity =
      InternetConnectivitySingleton();
  late final StreamSubscription _connectivitySubscription;

  ConnectivityCubit() : super(ConnectivityInitial()) {
    if (_connectivity.isConnected) {
      emit(ConnectivityConnected());
    } else {
      emit(ConnectivityDisconnected());
    }

    _connectivitySubscription = _connectivity.connectivityStream.listen((
      isConnected,
    ) {
      if (isConnected) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
