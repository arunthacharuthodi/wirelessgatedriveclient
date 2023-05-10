abstract class ServerConnectivityState {}

class ServerInitialState extends ServerConnectivityState {}

class ServerConnectedState extends ServerConnectivityState {}

class ServerDisConnectedState extends ServerConnectivityState {}

class ServerConnectionErrorState extends ServerConnectedState {}

class ServerErrorState extends ServerConnectedState {}

class GettingVoltageState extends ServerConnectedState {
  String voltageval;
  GettingVoltageState(this.voltageval);
}

class SendingMessageState extends ServerConnectedState {
  double messageval;
  SendingMessageState(this.messageval);
}
