import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wgdclient/controller/bloc/server_connectivity_bloc/server_connectivity_bloc.dart';
import 'package:wgdclient/controller/bloc/server_provider.dart';
import 'package:wgdclient/view/homepage/homepage.dart';
import 'package:wgdclient/view/server_setting.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ServerConnectivityBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => Homepage(),
          '/serverconf': (context) => ServerSettings()
        },
        theme: ThemeData(
          fontFamily: "inter",
          primarySwatch: Colors.blueGrey,
        ),
        // home: const Homepage(),
      ),
    );
  }
}
