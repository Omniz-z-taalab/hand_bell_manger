import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/account_package/agent_model.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/help/help_center_response.dart';

abstract class HelpState extends Equatable {
  const HelpState();

  @override
  List<Object> get props => [];
}

class HelpInitialState extends HelpState {}

class HelpLoadingState extends HelpState {}

class HelpErrorState extends HelpState {
  final String? error;

  HelpErrorState({required this.error});
}

class HelpLoadingEmails extends HelpState{}
class HelpSuccessEmails extends HelpState{
  final  List<UserData>? mails;
HelpSuccessEmails({required this.mails}){
  print(mails);
}
}
class HelpErrorEmails extends HelpState{}

// fetch
class AgentSuccessState extends HelpState {
  final List<AgentModel>? items;

  AgentSuccessState({required this.items});
}

