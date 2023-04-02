import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:wgdclient/helper/secure_storage.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:xterm/core.dart';
import 'package:xterm/ui.dart';

class ServerSettings extends StatefulWidget {
  const ServerSettings({super.key});

  @override
  State<ServerSettings> createState() => _ServerSettingsState();
}

class _ServerSettingsState extends State<ServerSettings> {
  final terminal = Terminal(maxLines: 10000);
  TextEditingController servertextcontroller = TextEditingController();
  TextEditingController portcontroller = TextEditingController();

  final terminalController = TerminalController();
  IO.Socket? socket;

  Future<void> setHost() async {
    if (await hasServerHost) {
      String? hosturl = await serverhost;
      setState(() {
        servertextcontroller.text = hosturl!;
      });
    }
  }

  @override
  void initState() {
    setHost();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    socket!.disconnect();
    socket!.dispose();
    super.dispose();
  }

  // late final Pty pty;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.refresh_rounded))
            ],
            elevation: 0,
            title: Text(
              "Server Settings",
              style: TextStyle(
                fontSize: 16,
              ),
            )),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Wireless gate drive server works on Socket.io ,  to connect client to server user have to provide server url and save it",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.gpp_good_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Server status",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Server url:",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54),
                                      ),
                                      Container(
                                        width: 200,
                                        child: SizedBox(
                                          height: 40,
                                          child: TextField(
                                            controller: servertextcontroller,
                                            decoration: InputDecoration(
                                              hintText: '127.0.0.1',
                                              filled: true,
                                              contentPadding: EdgeInsets.all(5),
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                              fillColor: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Server port:",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54),
                                      ),
                                      Container(
                                        width: 200,
                                        child: SizedBox(
                                          height: 40,
                                          child: TextField(
                                            controller: portcontroller,
                                            decoration: InputDecoration(
                                              hintText: 'ex: 3000',
                                              filled: true,
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                              fillColor: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                setServerHost("http://" +
                                    servertextcontroller.text.trim() +
                                    ":" +
                                    portcontroller.text.trim());
                                terminal.write(
                                    "connecting in to ${"http://" + servertextcontroller.text.trim() + ":" + portcontroller.text.trim()}\n");
                                if (await hasServerHost) {
                                  String? url = await serverhost;
                                  socket = IO.io(url, <String, dynamic>{
                                    'autoConnect': true,
                                    'transports': ['websocket'],
                                  });
                                  socket!.connect();
                                  socket!.on(
                                    "message",
                                    (data) {
                                      print(data.message);
                                    },
                                  );
                                  socket!.onConnect((_) {
                                    print('Connection established');
                                    terminal.write(
                                        "connection established to ${url} \n");
                                  });
                                  socket!.onDisconnect((_) {
                                    print('Connection Disconnection');
                                    terminal
                                        .write("Disconnected from ${url} \n");
                                  });
                                  socket!.onConnectError((err) =>
                                      terminal.write("Error ${err} \n"));
                                  socket!.onError((err) => print(err));
                                }
                              },
                              icon: const Icon(Icons.save_outlined))
                        ],
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  height: 200,
                  child: TerminalView(
                    terminal,
                    // readOnly: true,

                    controller: terminalController,
                    // autofocus: true,
                    backgroundOpacity: 0.7,
                    onSecondaryTapDown: (details, offset) async {
                      final selection = terminalController.selection;
                      if (selection != null) {
                        final text = terminal.buffer.getText(selection);
                        terminalController.clearSelection();
                        await Clipboard.setData(ClipboardData(text: text));
                      } else {
                        final data = await Clipboard.getData('text/plain');
                        final text = data?.text;
                        if (text != null) {
                          terminal.paste(text);
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
