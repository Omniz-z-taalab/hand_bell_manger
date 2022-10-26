part of 'global_bloc.dart';

abstract class GlobalState extends Equatable {
  const GlobalState();

  @override
  List<Object> get props => [];
}

class GlobalInitial extends GlobalState {}

class GlobalLoading extends GlobalState {}

class GlobalError extends GlobalState {}

class StartAppSuccess extends GlobalState {
  
}

class UserStatusChangeSuccess extends GlobalState {}
