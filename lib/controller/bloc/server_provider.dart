import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wgdclient/controller/services/server_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ServerProvider extends ChangeNotifier {
  bool isserverConnected = false;
  ServerService _server_service = ServerService();

  Future<void> connectToServer(IO.Socket socket) async {
    isserverConnected = await _server_service.connectToSocket(socket: socket);
    notifyListeners();
  }

  void onsocketdisconnect() {
    isserverConnected = false;
    notifyListeners();
    print("socketdisconnected");
  }

  void socketOnConnect() {
    isserverConnected = true;
    notifyListeners();
    print("socket connected");
  }

  Future<void> sendMessage(String message, IO.Socket socket) async {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
