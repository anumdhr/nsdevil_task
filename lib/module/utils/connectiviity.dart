import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivitySingleton {
  static final InternetConnectivitySingleton _instance =
      InternetConnectivitySingleton._internal();

  factory InternetConnectivitySingleton() {
    return _instance;
  }

  InternetConnectivitySingleton._internal() {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  bool _isConnected = false;

  Stream<bool> get connectivityStream => _connectivityController.stream;

  bool get isConnected => _isConnected;

  Future<bool> waitForInternet({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (_isConnected) return true;

    final completer = Completer<bool>();
    late StreamSubscription<bool> sub;

    sub = connectivityStream.listen((status) {
      if (status) {
        completer.complete(true);
        sub.cancel();
      }
    });

    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(_isConnected);
        sub.cancel();
      }
    });

    return completer.future;
  }

  void _init() async {
    print('Initializing InternetConnectivitySingleton...');
    await _checkInitialConnectivity();
    _listenToConnectivityChanges();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(result);
    } catch (e) {
      _isConnected = false;
      _connectivityController.add(_isConnected);
    }
  }

  void _listenToConnectivityChanges() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      print("Connectivity changed: ${result.runtimeType}");
      _updateConnectionStatus(result);
    });
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn) ||
        result.contains(ConnectivityResult.bluetooth) ||
        result.contains(ConnectivityResult.other)) {
      try {
        final lookup = await InternetAddress.lookup('google.com');
        if (lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty) {
          _isConnected = true;
          _connectivityController.add(_isConnected);
          print('Connected to internet');
        }
      } on SocketException {
        _isConnected = false;
        _connectivityController.add(_isConnected);
        print('Internet lookup failed');
      }
    } else {
      _isConnected = false;
      _connectivityController.add(_isConnected);
      print('Disconnected from network: $result');
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
  }
}
