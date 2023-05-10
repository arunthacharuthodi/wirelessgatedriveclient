abstract class ServerConnectivityEvents {}

class ServerDisConnectedEvent extends ServerConnectivityEvents {}

class ServerConnectedEvent extends ServerConnectivityEvents {}

class ServerConnectionErrorEvent extends ServerConnectivityEvents {}

class ServerErrorEvent extends ServerConnectivityEvents {
  String error;
  ServerErrorEvent(this.error);
}

class SendingMessageEvent extends ServerConnectivityEvents {
  double message;

  SendingMessageEvent(this.message);
}

class GettingVoltageEvent extends ServerConnectivityEvents {
  String voltage;
  GettingVoltageEvent(this.voltage);
}
