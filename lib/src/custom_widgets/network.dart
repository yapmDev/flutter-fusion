/*
  author: yapmDev
  lastModifiedDate: 10/02/25
  repository: https://github.com/yapmDev/flutter_fusion
 */

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///Provides a network availability checker based on [connectivity_plus] package to optimize
///[pingUrl] requests.
///
/// The recommended usage is once at the top level of your application, as shown below:
///
/// ```dart
/// MaterialApp.router(
///   builder: (context, child) => NetworkChecker(
///     pingUrl: 'http://10.0.2.2:8080/network-checker',
///     alert: _buildAlert(context),
///     child: child!
///   ),
///   routerConfig: appRouter,
/// );
/// ```
///
/// When a connection change is detected (internet loss or recovery) the [child] will be
/// automatically re-rendered. At any lower part of the hierarchy the connection status can be
/// accessed like this:
///
/// ```dart
/// final isConnected = NetworkProvider.of(context).isConnected;
/// ```
class NetworkChecker extends StatefulWidget {

  final String pingUrl;

  ///A optional custom alert widget to display if the app is not connected successfully.
  final Widget? alert;

  ///An optional position to the [alert]. If [null] [Alignment.bottomCenter] will be apply.
  final Alignment? alertPosition;

  ///The child of this widget. Normally your app entrypoint.
  final Widget child;

  ///Creates a network availability checker.
  const NetworkChecker({
    super.key,
    this.alert,
    this.alertPosition,
    required this.pingUrl,
    required this.child,
  });

  @override
  State<NetworkChecker> createState() => _NetworkCheckerState();
}

class _NetworkCheckerState extends State<NetworkChecker>{

  final Connectivity _connectivity = Connectivity();
  final NetworkNotifier _notifier = NetworkNotifier();

  @override
  void initState() {
    _checkServerAvailability();
    _startMonitoring();
    super.initState();
  }

  void _startMonitoring() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _checkServerAvailability();
    });
  }

  Future<void> _checkServerAvailability() async {
    bool newStatus;
    try {
      final response = await http.get(Uri.parse(widget.pingUrl));
      newStatus = response.statusCode == 200;
    } catch(_) {
      newStatus = false;
    }
    if(newStatus != _notifier.isConnected){
      setState(()=> _notifier.updateStatus(newStatus));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand ,children: [
      NetworkProvider(
          notifier: _notifier,
          child: widget.child
      ),
      if(!_notifier.isConnected)
        Align(
          alignment: widget.alertPosition ?? Alignment.bottomCenter,
          child: widget.alert,
        )
    ]);
  }
}

///A notifier for connection status listeners used on [NetworkChecker].
class NetworkNotifier extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  ///Notify the listeners with a new connection status.
  void updateStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }
}

/// An inherited widget that provides [NetworkNotifier] to its descendants.
class NetworkProvider extends InheritedNotifier<NetworkNotifier> {

  /// Creates a [NetworkProvider] with the given [notifier] and [child].
  const NetworkProvider({
    super.key,
    required super.notifier,
    required super.child
  });

  /// Retrieves the nearest [NetworkNotifier] up the widget tree.
  static NetworkNotifier of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NetworkProvider>()!.notifier!;
  }
}