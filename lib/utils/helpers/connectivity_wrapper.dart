import 'package:docveda_app/common/widgets/no_internet_screen/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/utils/helpers/connectivity_util.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    ConnectivityUtil.onConnectionChanged.listen((connected) {
      setState(() {
        _isConnected = connected;
      });
    });
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final hasInternet = await ConnectivityUtil.hasInternetConnection();
    setState(() {
      _isConnected = hasInternet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected ? widget.child : const NoInternetScreen();
  }
}
