import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

/// Test method that wraps given widget in MaterialApp for testing more representative of real use
Widget buildTestableWidget(Widget widget, {MockNavigatorObserver mockNavigatorObserver}) {
  return MaterialApp(
    home: Builder(
      builder: (context) {
        return widget;
      },
    ),
    navigatorObservers: [mockNavigatorObserver],
  );
}
