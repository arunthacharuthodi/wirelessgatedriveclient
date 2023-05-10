import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wgdclient/appconfig.dart';
import 'package:wgdclient/controller/bloc/server_connectivity_bloc/server_connectivity_bloc.dart';
import 'package:wgdclient/controller/bloc/server_connectivity_bloc/server_connectivity_event.dart';
import 'package:wgdclient/controller/bloc/server_connectivity_bloc/server_connectivity_state.dart';
import 'package:wgdclient/controller/bloc/server_provider.dart';

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppConfig().primaryColor,
            ),
            elevation: 1,
            backgroundColor: Colors.white,
            title: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 18.0),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Wireless ',
                      style: TextStyle(
                          color: AppConfig().textColor,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'Gate Drive',
                      style: TextStyle(
                          color: AppConfig().primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
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
                leading: Icon(
                  Icons.auto_graph_outlined,
                  color: AppConfig().primaryColor,
                ),
                title: Text('Dashbord'),
                onTap: () {
                  // Do something
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.troubleshoot_sharp,
                  color: AppConfig().primaryColor,
                ),
                title: Text('Trouble Shoot'),
                onTap: () {
                  // Do something
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.computer,
                  color: AppConfig().primaryColor,
                ),
                title: Text('Server Settings'),
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.of(context).pushNamed('/serverconf');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.adb_outlined,
                  color: AppConfig().primaryColor,
                ),
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
          // child: CustomScrollView(slivers: [
          //   SliverToBoxAdapter(
          //     child: Container(
          //       margin: EdgeInsets.only(top: 20),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(3),
          //           color: Colors.white,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Color.fromRGBO(0, 0, 0, 0.25),
          //               offset: Offset(0, 1),
          //               blurRadius: 4,
          //               spreadRadius: 0,
          //             ),
          //           ]),
          //       padding: EdgeInsets.only(top: 10),
          //       width: MediaQuery.of(context).size.width,
          //       height: 250,
          //       child: Column(
          //         children: [
          //           Text(
          //             "Analytics",
          //             style: TextStyle(
          //                 fontSize: 15,
          //                 fontWeight: FontWeight.bold,
          //                 color: AppConfig().textColor),
          //           ),
          //         ],
          //       ),
          //     ),
          //   )
          // ]),

          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     Icon(
                  //         value.isserverConnected
                  //             ? Icons.signal_wifi_4_bar_sharp
                  //             : Icons
                  //                 .signal_wifi_statusbar_connected_no_internet_4_sharp,
                  //         color: value.isserverConnected
                  //             ? Colors.green[600]
                  //             : Colors.grey),
                  //     Text(
                  //       value.isserverConnected
                  //           ? "Connected"
                  //           : "Not Connected",
                  //       style: TextStyle(
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.bold,
                  //           color: value.isserverConnected
                  //               ? Colors.green[600]
                  //               : Colors.grey),
                  //     )
                  //   ],
                  // ),
                  BlocConsumer<ServerConnectivityBloc, ServerConnectivityState>(
                    listener: (context, state) {
                      // TODO: implement listener
                      // if (state is ServerConnectedState) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text("server connected"),
                      //     backgroundColor: Colors.green,
                      //   ));
                      // } else if (state is ServerDisConnectedState) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text("server dis connected"),
                      //     backgroundColor: Colors.red[300],
                      //   ));
                      // } else if (state is ServerErrorState) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text("connection error"),
                      //     backgroundColor: Colors.red[300],
                      //   ));
                      // }
                    },
                    builder: (context, state) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (state is ServerConnectedState) ...[
                            Icon(
                              Icons.signal_wifi_4_bar_sharp,
                              color: Colors.green,
                            ),
                            Text(
                              "Connected",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[600]),
                            ),
                          ] else if (state is ServerDisConnectedState) ...[
                            Icon(Icons.signal_wifi_4_bar_sharp),
                            Text(
                              "Disconnected",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            ),
                          ] else ...[
                            Text("server connection error")
                          ],

                          //     : Icons
                          //         .signal_wifi_statusbar_connected_no_internet_4_sharp,
                          // color: state is ServerConnectedState
                          //     ? Colors.green[600]
                          //     : Colors.grey),

                          // if (state is ServerErrorState ||
                          //     state is ServerConnectionErrorState) ...[

                          // ]
                        ],
                      );
                    },
                  ),
                  BlocBuilder<ServerConnectivityBloc, ServerConnectivityState>(
                    builder: (context, state) {
                      return Container(
                        child: Column(children: [
                          Text("voltage"),
                          Text(
                            state is GettingVoltageState
                                ? state.voltageval.toString()
                                : "0v",
                            style: TextStyle(fontSize: 28),
                          ),
                        ]),
                      );
                    },
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
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BlocBuilder<ServerConnectivityBloc,
                        ServerConnectivityState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text(state is SendingMessageState
                                ? state.messageval.toString()
                                : ""),
                            Slider(
                              thumbColor: AppConfig().primaryColor,
                              activeColor: AppConfig().primaryColor,

                              divisions: 15,
                              // label: _basevalue.toString(),
                              value: state is SendingMessageState
                                  ? state.messageval
                                  : 0,
                              min: 0,
                              max: 15,
                              onChanged: (value) {
                                setState(() {
                                  _basevalue = value;
                                });

                                BlocProvider.of<ServerConnectivityBloc>(context)
                                    .add(SendingMessageEvent(_basevalue));
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 30),
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(bottom: 8.0),
                    //         child: TextFormField(
                    //           controller: dutycyclecontroller,
                    //           decoration: InputDecoration(
                    //               border: new OutlineInputBorder(
                    //                 borderRadius:
                    //                     new BorderRadius.circular(8.0),
                    //                 borderSide: new BorderSide(),
                    //               ),
                    //               hintText: "Enter your duty cycle"),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: double.infinity,
                    //         child: ElevatedButton(
                    //           onPressed: () {
                    //             // initSocket();
                    //             // sendMessage(dutycyclecontroller.text.trim());
                    //             // ServerProvider().sendMessage(
                    //             //     dutycyclecontroller.text.trim(), socket!);
                    //           },
                    //           child: Text("upload"),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
