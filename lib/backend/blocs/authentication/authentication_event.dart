import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class GoogleSignInButtonTapped implements AuthenticationEvent {
  @override
  List<Object> get props => [];
}

