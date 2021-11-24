import 'package:blind_alarm/serial_manager.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import './library.dart' as CtLib;
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
  Map<String, dynamic> btConn = {
    "conn": null,
    "name": null,
    "address": "",
  };

  void timeSetting(BuildContext context) async {
    log(btConn["conn"].toString());
    if (btConn["conn"] == null) {
      CtLib.ctAlert(context, "블루투스 연결을 먼저 해주세요.");
    } else {
      final result = await Navigator.pushNamed(context, '/AlarmSetting',
          arguments: btConn);
      log(result.toString());
      if (result != null) {
        setState(() {
          timeData = result;
        });
      }
    }
  }

  void serialSetting() async {
    var btResult = await Navigator.pushNamed(context, '/SerialSetting');
    //btResult == null이면 그냥 뒤로가기 누른 것임
    if (btResult != null) {
      btResult = btResult as Map<String, dynamic>;
      btConn["conn"] = btResult["conn"];
      btConn["name"] = btResult["deviceName"];
      btConn["address"] = btResult["deviceAddress"];
      setState(() {}); //how to setState with map
      log("블루투스 연결 정보: ${btConn["name"]}"); //DEBUG
    }
  }

  void serialDisconnect() {
    if (btConn["conn"] != null) {
      btConn["conn"].close(); //disconnect
    }
    btConn["conn"] = null;
    btConn["name"] = null;
    btConn["address"] = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // 알람 View //
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text("알람: $timeData"),
                ),
                Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.purple),
                      ),
                      onPressed: () {
                        timeSetting(context);
                      },
                      child: const Text('알람설정'),
                    )),
              ],
            ),
          ),
          // 블루투스 View //
          Expanded(
            flex: 1,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text("블루투스 연결 정보: ${btConn["name"].toString()}"),
              ),
              Container(
                  //connect Btn
                  padding: const EdgeInsets.only(bottom: 3),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      serialSetting();
                    },
                    child: const Text('블루투스 연결'),
                  )),
              Container(
                  //disconnect Btn
                  padding: const EdgeInsets.only(bottom: 3),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      serialDisconnect();
                    },
                    child: const Text('블루투스 연결 해제'),
                  ))
            ]),
          )
        ]),
      ),
    );
  }
}
