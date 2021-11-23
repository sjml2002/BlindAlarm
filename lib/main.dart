import 'package:blind_alarm/serial_manager.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import './alarm_setting.dart';
//////// import ////////

void main() {
  runApp(const MyApp());
}

//글로벌 네비게이터 키
final navigatorKey = GlobalKey<NavigatorState>();

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
        '/SerialSetting': (context) => const SerialManagerMain(),
      },
      navigatorKey: navigatorKey,
    );
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

  void serialSetting() async {
    final result = await Navigator.pushNamed(context, '/SerialSetting');
    log(result.toString());
    log("블루투스 연결");
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
                // 알람 설정 버튼 //
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
                    )),
                // 블루투스 연결 버튼 //
                Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        serialSetting();
                      },
                      child: const Text('블루투스 연결'),
                    ))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
