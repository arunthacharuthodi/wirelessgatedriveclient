import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController dutycyclecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("WGD CLIENT")),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Column(children: [
                          Text("voltage"),
                          Text("19V", style: TextStyle(fontSize: 28),),

                        ]),
                        
                      ),
                      Container(
                        child: Column(children: [
                          Text("current"),
                          Text("1A", style: TextStyle(fontSize: 28),),

                        ]),
                        
                      )
                    ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom:8.0),
                        child: TextFormField(
                          controller: dutycyclecontroller,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide(),
                            ),
                            hintText: "Enter your duty cycle"
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton( onPressed: () {  },
                        child: Text("upload"),),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}