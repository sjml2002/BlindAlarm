import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:blind_alarm/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// ignore: library_prefixes
import './library.dart' as CtLib;

class SerialManagerMain extends StatefulWidget {
  const SerialManagerMain({Key? key}) : super(key: key);

  @override
  State<SerialManagerMain> createState() => SerialManager();
}

class SerialManager extends State<SerialManagerMain> {
  List<BluetoothDiscoveryResult> results = [];
  List devicesName = [];
  List devicesAddress = [];
  bool isDiscovery = false;

  SerialManager() {
    managerMain();
  }
  //// root method ////
  void managerMain() {
    requestLocationPermission();
    startDiscovery(); //블루투스 디바이스 검색
  }

  ///// 위치 권한 얻기 /////
  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (!status.isGranted) {
      //권한 허용이 안된 경우
      String cont = "권한 설정을 다시 확인해주세요";
      CtLib.ctAlert(navigatorKey.currentState!.overlay!.context, cont);
      return false;
    } else {
      //권한 허용됨
      log("권한 허용됨");
      return true;
    }
  }

  ///// 블루투스 장치 검색 /////
  void startDiscovery() {
    log("블루투스 장치 검색 중"); //DEBUG
    var streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      if (!CtLib.isListInItem(devicesAddress, r.device.address.characters)) {
        setState(() {
          results.add(r);
          devicesName.add(r.device.name);
          devicesAddress.add(r.device.address.characters);
        });
      }
    });
    log("devices: ${devicesAddress.toString()}"); //DEBUG
    log("results: ${results.toString()}");
    streamSubscription.onDone(() {
      //FlutterBluetoothSerial.instance.cancelDiscovery();
    });
  }

  ///// 검색된 장치 중 하나 연결 /////
  Future<void> btConnect(
      Map<String, String> deviceInfo, BuildContext context) async {
    Map<String, dynamic> btInfo = {
      "conn": null,
      "deviceName": "",
      "deviceAddress": "",
    };
    try {
      var conn = await BluetoothConnection.toAddress(deviceInfo["address"]);
      conn.input!.listen((Uint8List data) {
        log(ascii.decode(data));
      });
      btInfo["conn"] = conn;
      btInfo["deviceName"] = deviceInfo["name"];
      btInfo["deviceAddress"] = deviceInfo["address"];
      Navigator.pop(context, btInfo);
    } catch (e) {
      CtLib.ctAlert(context, "연결할 수 없음!\n예외발생");
      log('연결할 수 없음 예외 발생');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Connect"),
      ),
      body: Column(
        children: [
          TextButton(
            child: const Text("블루투스 장치 재 검색"),
            onPressed: managerMain,
          ),

          const Text(" "),
          const Text("devicesName"),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: devicesName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextButton(
                        child: Column(
                          children: [
                            Text('name: ${devicesName[index]}'),
                            Text('address: ${devicesAddress[index]}'),
                          ],
                        ),
                        onPressed: () {
                          Map<String, String> deviceInfo = {
                            "name": devicesName[index].toString(),
                            "address": devicesAddress[index].toString(),
                          };
                          btConnect(deviceInfo, context);
                        },
                      ),
                    );
                  })),
          //   ListView.builder(
          //     itemCount: results.length,
          //     itemBuilder: (BuildContext context, index) {
          //       BluetoothDiscoveryResult deviceList = results[index];
          //       final device = deviceList.device;
          //       final address = deviceList.rssi;
          //       return Row(
          //         children: <Widget>[
          //           Text("device: $device"),
          //           Text("address: $address"),
          //         ],
          //       );
          //     },
          //   ),
          //   Expanded(
          //       child: Row(children: [
          //     Container(
          //         padding: const EdgeInsets.only(bottom: 8),
          //         child: TextButton(
          //           style: ButtonStyle(
          //             foregroundColor:
          //                 MaterialStateProperty.all<Color>(Colors.blue),
          //           ),
          //           onPressed: () {
          //             startDiscovery();
          //           },
          //           child: const Text('블루투스 장치 다시 검색'),
          //         )),
          //   ])),
        ],
      ),
    );
  }
}

class BLEcontrol {
  ///// 연결된 장치로 데이터 전달 /////
  static Future btSendData(BluetoothConnection conn, String data) async {
    List<int> list = data.codeUnits;
    Uint8List send = Uint8List.fromList(list);
    conn.output.add(send);
    await conn.output.allSent;
  }
}
