import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_event.dart';
import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_state.dart';
import 'package:bloc_listener_tests/frontend/screens/dashboard_screen.dart';
import 'package:bloc_listener_tests/frontend/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as dartTest;

import '../../test_utils/widget_test_utils.dart';

class AuthenticationBlocMock extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

void main() {
  AuthenticationBlocMock authenticationBlocMock;
  FirebaseUserMock firebaseUserMock;
  MockNavigatorObserver mockNavigatorObserver;

  var subject;

  dartTest.setUp(() {
    firebaseUserMock = FirebaseUserMock();
    authenticationBlocMock = AuthenticationBlocMock();
    mockNavigatorObserver = MockNavigatorObserver();

    subject = buildTestableWidget(SignInScreen(authenticationBloc: authenticationBlocMock),
        mockNavigatorObserver: mockNavigatorObserver);

    // have to pass the initial state to the widget manually since it's a stub
    whenListen(authenticationBlocMock, Stream.value(AuthenticationUninitialized()));
  });

  dartTest.tearDown(() {
    authenticationBlocMock?.close();
  });

  group('Sign In Screen tests', () {
    final findBlocBuilder = find.byKey(Key('authenticationBlocBuilder'));
    final findScaffold = find.byKey(Key('signInScaffold'));
    final findTitleButtonOverlay = find.byKey(Key('titleButtonOverlay'));
    final findGoogleSignInButton = find.byKey(Key('signInGoogleButton'));

    testWidgets('Test Sign In Screen basic structure with AuthenticationUnitialized state',
        (WidgetTester tester) async {
      whenListen(authenticationBlocMock, Stream.value(AuthenticationUninitialized()));

      await tester.pumpWidget(subject);

      expect(findBlocBuilder, findsOneWidget);
      expect(findScaffold, findsOneWidget);

      expect(findTitleButtonOverlay, findsOneWidget);
    });

    testWidgets('Test Google Sign In button interaction with AuthenticationUninitialized state',
        (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      await tester.tap(findGoogleSignInButton);

      verify(authenticationBlocMock.add(argThat(isA<GoogleSignInButtonTapped>()))).called(1);
    });

    testWidgets(
      'Test build with AuthenticationSuccess state should push /dashboard route',
      (WidgetTester tester) async {
        when(authenticationBlocMock.state)
            .thenAnswer((_) => AuthenticationSuccess(firebaseUser: firebaseUserMock));

//        whenListen(
//          authenticationBlocMock,
//          Stream.fromIterable([AuthenticationSuccess(firebaseUser: firebaseUserMock)]),
//        );

//        dartTest.expectLater(authenticationBlocMock,
//            emitsInOrder([AuthenticationSuccess(firebaseUser: firebaseUserMock)]));

        await tester.pumpWidget(subject);

        await tester.pumpAndSettle();
        verify(mockNavigatorObserver.didPush(any, any));
//        expect(find.byKey(Key('SignInBlocListener')), findsOneWidget);

//      await tester.tap(findGoogleSignInButton);

//      when(firebaseUserMock.displayName).thenReturn('Display Name');

//      final List pushedRoute = verify(mockNavigatorObserver.didPush(captureAny, any)).captured;
//      var result = pushedRoute. .currentResult.toString();
        expect(find.byType(DashboardScreen), findsOneWidget);
      },
    );

    testWidgets(
      'Test build with AuthenticationFailure state',
      (WidgetTester tester) async {
        await tester.pumpWidget(subject);
      },
      skip: true,
    );

    testWidgets(
      'Test build with AuthenticationError state',
      (WidgetTester tester) async {
        await tester.pumpWidget(subject);
      },
      skip: true,
    );
  });
}
