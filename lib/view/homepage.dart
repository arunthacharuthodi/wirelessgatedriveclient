import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:wgdclient/controller/provider/server_provider.dart';
import 'package:wgdclient/controller/services/server_service.dart';
import 'package:wgdclient/helper/secure_storage.dart';
import 'package:wgdclient/repository/duty.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController _textController = TextEditingController();

  double _basevalue = 0;
  TextEditingController dutycyclecontroller = TextEditingController();
  IO.Socket? socket;

  @override
  void dispose() {
    // TODO: implement dispose
    socket!.destroy();
    super.dispose();
  }

  @override
  void initState() {
    iOInit();
    // TODO: implement intState
    super.initState();
  }

  Future<void> iOInit() async {
    if (await hasServerHost) {
      String? url = await serverhost;
      socket = IO.io(url, <String, dynamic>{
        'autoConnect': true,
        'transports': ['websocket'],
      });
      socket!.connect();
      socket!.onConnect((data) =>
          Provider.of<ServerProvider>(context, listen: false)
              .socketOnConnect());
      socket!.onDisconnect((data) =>
          Provider.of<ServerProvider>(context, listen: false)
              .onsocketdisconnect());
      socket!.onConnectError((err) => print(err));
      socket!.onError((err) => print(err));
    } else {}
    // Provider.of<ServerProvider>(context, listen: false)
    //     .connectToServer(socket!);
    // socket!.onDisconnect((_) {
    //   print('Connection Disconnection - change state');
    //   Provider.of<ServerProvider>(context, listen: false).onsocketdisconnect();
    // });
    // socket!.onConnect((_) {
    //   print('Connection established');
    //   Provider.of<ServerProvider>(context, listen: false).socketOnConnect();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text(
              "Wireless gate Drive",
              style: TextStyle(
                fontSize: 16,
              ),
            )),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(30),
                child: Text('Wireless gate drive client - version 1.0'),
                decoration: BoxDecoration(
                    // color: Colors.blue,
                    ),
              ),
              ListTile(
                leading: Icon(Icons.auto_graph_outlined),
                title: Text('Dashbord'),
                onTap: () {
                  // Do something
                },
              ),
              ListTile(
                leading: Icon(Icons.troubleshoot_sharp),
                title: Text('Trouble Shoot'),
                onTap: () {
                  // Do something
                },
              ),
              ListTile(
                leading: Icon(Icons.computer),
                title: Text('Server Settings'),
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.of(context).pushNamed('/serverconf');
                },
              ),
              ListTile(
                leading: Icon(Icons.adb_outlined),
                title: Text('About'),
                onTap: () {
                  // Do something
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<ServerProvider>(
            builder: (context, value, child) => Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                            value.isserverConnected
                                ? Icons.signal_wifi_4_bar_sharp
                                : Icons
                                    .signal_wifi_statusbar_connected_no_internet_4_sharp,
                            color: value.isserverConnected
                                ? Colors.green[600]
                                : Colors.grey),
                        Text(
                          value.isserverConnected
                              ? "Connected"
                              : "Not Connected",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: value.isserverConnected
                                  ? Colors.green[600]
                                  : Colors.grey),
                        )
                      ],
                    ),
                    Container(
                      child: Column(children: [
                        Text("voltage"),
                        Text(
                          "19V",
                          style: TextStyle(fontSize: 28),
                        ),
                      ]),
                    ),
                    Container(
                      child: Column(children: [
                        Text("current"),
                        Text(
                          "1A",
                          style: TextStyle(fontSize: 28),
                        ),
                      ]),
                    )
                  ],
                ),
                Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Slider(
                        divisions: 255,
                        label: _basevalue.toString(),
                        value: _basevalue,
                        min: 0,
                        max: 255,
                        onChanged: (value) {
                          setState(() {
                            _basevalue = value;
                          });
                          ServerProvider()
                              .sendMessage(value.toString(), socket!);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextFormField(
                                controller: dutycyclecontroller,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: "Enter your duty cycle"),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // initSocket();
                                  // sendMessage(dutycyclecontroller.text.trim());
                                  ServerProvider().sendMessage(
                                      dutycyclecontroller.text.trim(), socket!);
                                },
                                child: Text("upload"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
