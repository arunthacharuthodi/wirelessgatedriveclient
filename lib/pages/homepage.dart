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
        body: Container(
          child: Column(
            children: [
              Row(
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
              TextFormField(
                controller: dutycyclecontroller,
                decoration: InputDecoration(
                  hintText: "enter your duty cycle"
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton( onPressed: () {  },
                child: Text("upload"),),
              )
            ],
          )
        ),
      ),
    );
  }
}