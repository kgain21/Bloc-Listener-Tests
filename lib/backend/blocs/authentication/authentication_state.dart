import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final FirebaseUser firebaseUser;

  const AuthenticationSuccess({@required this.firebaseUser});

  @override
  List<Object> get props => [firebaseUser];

  @override
  String toString() => '''AuthenticationSuccess: { firebaseUser: $firebaseUser }''';
}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {}
