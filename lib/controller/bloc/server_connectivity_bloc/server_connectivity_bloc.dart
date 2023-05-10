import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wgdclient/controller/bloc/server_connectivity_bloc/server_connectivity_event.dart';
import 'package:wgdclient/controller/bloc/server_connectivity_bloc/server_connectivity_state.dart';
import 'package:wgdclient/helper/secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ServerConnectivityBloc
    extends Bloc<ServerConnectivityEvents, ServerConnectivityState> {
  //socket server connection
  IO.Socket? socket;

  ServerConnectivityBloc() : super(ServerInitialState()) {
    on<ServerConnectedEvent>((event, emit) => emit(ServerConnectedState()));
    on<ServerDisConnectedEvent>(
        (event, emit) => emit(ServerDisConnectedState()));
    on<ServerConnectionErrorEvent>(
        (event, emit) => emit(ServerConnectionErrorState()));

    on<ServerErrorEvent>((event, emit) => emit(ServerErrorState()));

    on<GettingVoltageEvent>(
        (event, emit) => emit(GettingVoltageState(event.voltage)));

    socket = IO.io("http://192.168.167.36:3000/?EIO=4/", <String, dynamic>{
      'autoConnect': true,
      'transports': ['websocket'],
    });
    socket!.connect();
    socket!.onConnect((data) {
      print("connected to server");
      add(ServerConnectedEvent());
    });
    // socket!.on('message', (data) => print(data));
    socket!.onDisconnect((data) => add(ServerDisConnectedEvent()));
    socket!.onConnectError((err) => add(ServerConnectionErrorEvent()));
    socket!.onError((err) => add(ServerErrorEvent(err)));
    socket!.on(
      'voltage',
      (data) {
        print("got message" + data.toString());
        add(GettingVoltageEvent(data.voltage));
      },
    );

    on<SendingMessageEvent>((event, emit) {
      emit(SendingMessageState(event.message));
      socket!.emit(
        "message",
        {
          "id": socket!.id,
          "voltage_client": event.message, // Message to be sent
          "timestamp": DateTime.now().millisecondsSinceEpoch,
        },
      );
    });
  }
  @override
  Future<void> close() {
    // TODO: implement close
    socket!.close();
    return super.close();
  }
}
