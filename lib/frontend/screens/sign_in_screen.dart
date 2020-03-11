import 'dart:ui';

import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_event.dart';
import 'package:bloc_listener_tests/backend/blocs/authentication/authentication_state.dart';
import 'package:bloc_listener_tests/frontend/screens/dashboard_screen.dart';
import 'package:bloc_listener_tests/frontend/util_widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;

  SignInScreen({Key key, @required this.authenticationBloc}) : super(key: key);

  @override
  Widget build(context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      key: Key('SignInBlocListener'),
      bloc: authenticationBloc,
      listener: (context, state) {
        if (state is AuthenticationSuccess) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        key: Key('authenticationBlocBuilder'),
        bloc: authenticationBloc,
        builder: (context, state) {
          if(state is AuthenticationInProgress) {
            return LoadingIndicator();
          }
          return Scaffold(
            key: Key('signInScaffold'),
            body: Center(
              child: buildTitleButtonOverlay(context),
            ),
          );
        },
      ),
    );
  }

  Widget buildTitleButtonOverlay(BuildContext context) {
    return Column(
      key: Key('titleButtonOverlay'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildTitleRow(context),
        buildSignInGoogleButtonRow(context),
        buildSignInGuestButtonRow(context),
      ],
    );
  }

  Widget buildTitleRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'BlocListener Tests',
            key: Key('signInTitle'),
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  Widget buildSignInGoogleButtonRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 45.0,
          minWidth: 275.0,
        ),
        child: RaisedButton(
          key: Key('signInGoogleButton'),
          onPressed: () => authenticationBloc.add(GoogleSignInButtonTapped()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/images/google_logo.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'SIGN IN WITH GOOGLE',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget buildSignInGuestButtonRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 45.0,
          minWidth: 275.0,
        ),
        child: RaisedButton(
          key: Key('signInGuestButton'),
          onPressed: () => null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'CONTINUE AS A GUEST',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
