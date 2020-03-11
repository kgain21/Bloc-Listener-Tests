import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('dashboardScaffold'),
      body: Container(
        child: Center(child: Text('Dashboard')),
      ),
    );
  }
}
