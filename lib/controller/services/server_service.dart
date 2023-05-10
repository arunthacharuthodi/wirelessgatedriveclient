import 'package:wgdclient/helper/secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ServerService {
  Future<bool> connectToSocket({required IO.Socket? socket}) async {
    try {
      if (await hasServerHost) {
        String? url = await serverhost;
        socket = IO.io(url, <String, dynamic>{
          'autoConnect': true,
          'transports': ['websocket'],
        });
        socket.connect();

        return socket.connected ? true : false;

        // socket!.onConnectError((err) => print(err));
        // socket!.onError((err) => print(err));
      } else {
        return false;
      }
    } catch (e) {
      print(e);

      return false;
    }
  }
}
