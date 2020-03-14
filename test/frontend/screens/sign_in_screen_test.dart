import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_event.dart';
import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_state.dart';
import 'package:bloc_listener_tests/frontend/screens/dashboard_screen.dart';
import 'package:bloc_listener_tests/frontend/screens/sign_in_screen.dart';
import 'package:bloc_listener_tests/frontend/util_widgets/loading_indicator.dart';
import 'package:bloc_test/bloc_test.dart';
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
  });

  dartTest.tearDown(() {
    authenticationBlocMock?.close();
  });

  group('Sign In Screen tests', () {
    final findBlocBuilder = find.byKey(Key('authenticationBlocBuilder'));
    final findScaffold = find.byKey(Key('signInScaffold'));
    final findTitleButtonOverlay = find.byKey(Key('titleButtonOverlay'));
    final findGoogleSignInButton = find.byKey(Key('signInGoogleButton'));
    final findLoadingIndicator = find.byType(LoadingIndicator);

    testWidgets('Test Sign In Screen basic structure with AuthenticationUnitialized state',
        (WidgetTester tester) async {
      whenListen(authenticationBlocMock, Stream.value(AuthenticationUninitialized()));

      expectLater(authenticationBlocMock, emitsInOrder([AuthenticationUninitialized()]));
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
      'Test build with AuthenticationInProgress state should show LoadingIndicator',
      (WidgetTester tester) async {
        when(authenticationBlocMock.state).thenAnswer((_) => AuthenticationInProgress());

        await tester.pumpWidget(subject);

        expect(findLoadingIndicator, findsOneWidget);
      },
    );

    testWidgets(
      'Test listen for AuthenticationSuccess state should show Dashboard',
      (WidgetTester tester) async {
        whenListen<AuthenticationEvent, AuthenticationState>(
          authenticationBlocMock,
          Stream.fromIterable([
            AuthenticationInProgress(),
            AuthenticationSuccess(firebaseUser: firebaseUserMock),
          ]),
        );

        await tester.pumpWidget(subject);

        await tester.pumpAndSettle();

        verify(mockNavigatorObserver.didPush(any, any));

        expect(find.byType(DashboardScreen), findsOneWidget);

        await tester.pumpAndSettle();
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
