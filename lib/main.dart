import 'package:flutter/material.dart';
import 'dart:developer';

import './alarm_setting.dart';
//////// import ////////

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: 'Blind Alarm'),
          '/AlarmSetting': (context) => AlarmSetting(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var timeData;

  void timeSetting() async {
    final result = await Navigator.pushNamed(context, '/AlarmSetting');
    log(result.toString());
    setState(() {
      timeData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Row(
              children: [
                Text("알람: $timeData"),
                Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () {
                        timeSetting();
                      },
                      child: const Text('알람설정'),
                    ))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
