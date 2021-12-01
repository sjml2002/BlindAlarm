import 'dart:developer';

import 'package:flutter/material.dart';

import './serial_manager.dart';

class AlarmSetting extends StatelessWidget {
  Map<String, dynamic> btConn = {
    "conn": null,
    "name": null,
    "address": "",
  };
  var AlarmData = AlarmDataDTO();

  final TextEditingController _yearControl =
      TextEditingController(text: DateTime.now().year.toString());
  final TextEditingController _monthControl =
      TextEditingController(text: DateTime.now().month.toString());
  final TextEditingController _dateControl =
      TextEditingController(text: DateTime.now().day.toString());
  final TextEditingController _hourControl =
      TextEditingController(text: DateTime.now().hour.toString());
  final TextEditingController _minuteControl =
      TextEditingController(text: DateTime.now().minute.toString());

  AlarmSetting({Key? key}) : super(key: key);

  String textValidator(String text) {
    if (text != '') {
      return text;
    } else {
      return '0';
    }
  }

  Future<void> sendTimeData(context) async {
    int yearData = int.parse(textValidator(_yearControl.text));
    int monthData = int.parse(textValidator(_monthControl.text));
    int dateData = int.parse(textValidator(_dateControl.text));
    int hourData = int.parse(textValidator(_hourControl.text));
    int minuteData = int.parse(textValidator(_minuteControl.text));
    Map<String, dynamic> res =
        AlarmData.setTime(yearData, monthData, dateData, hourData, minuteData);
    if (res["result"] == true) {
      // 아두이노로 데이터 보내기 //
      BLEcontrol.btSendData(btConn["conn"], AlarmData.getTimeWithHC06());
      Navigator.pop(context, AlarmData.getTime());
      ////////////////////////////
    } else {
      log("시간 잘못 설정됨");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("알람 설정 오류"),
              content: Text(res["msg"]),
              actions: <Widget>[
                TextButton(
                  child: const Text('cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    btConn["conn"] = args["conn"];
    btConn["name"] = args["name"];
    btConn["address"] = args["address"];
    return Scaffold(
        appBar: AppBar(
          title: const Text("알람 설정"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: <Widget>[
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _yearControl,
                    ),
                  ),
                  const Text("년 "),
                  const Padding(padding: EdgeInsets.only(right: 15)),
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _monthControl,
                    ),
                  ),
                  const Text("월 "),
                  const Padding(padding: EdgeInsets.only(right: 15)),
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _dateControl,
                    ),
                  ),
                  const Text("일 "),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          controller: _hourControl,
                        ),
                      ),
                      const Text("시 "),
                      const Padding(padding: EdgeInsets.only(right: 25)),
                      Flexible(
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          controller: _minuteControl,
                        ),
                      ),
                      const Text("분 "),
                    ]),
                //시간 입력과 버튼을 나누는 선
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(height: 2.0, color: Colors.purpleAccent),
                ),
                Row(
                  //send TimeData
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                            width: 100,
                            height: 50,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.deepPurpleAccent.shade200),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              onPressed: () => {sendTimeData(context)},
                              child: const Text(
                                '알람설정',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ))),
                  ],
                )
              ],
            )));
  }
}

// AlarmData Form //
class AlarmDataDTO {
  int? year;
  int? month;
  int? date;
  int? hour;
  int? minute;

  AlarmDataDTO() {
    year = DateTime.now().year;
    month = DateTime.now().month;
    date = DateTime.now().day;
    hour = DateTime.now().hour;
    minute = DateTime.now().minute;
  }

  int timeCompare(DateTime now, DateTime data) {
    return int.parse(data.difference(now).inMinutes.toString());
  }

  //시간을 제대로 입력했는지 검사
  Map<String, dynamic> checkTime(int y, int m, int d, int h, int min) {
    Map<String, dynamic> returnData = {
      "result": true,
      "msg": "알람 설정!",
    };
    DateTime dataTmp = DateTime(y, m, d, h, min);
    int res = timeCompare(DateTime.now(), dataTmp);

    if (!(1 <= m && m <= 12)) {
      returnData["result"] = false;
      returnData["msg"] = "오류!\n1월~12월 사이로 입력해주세요.";
    } else if (!(1 <= d && d <= 31)) {
      returnData["result"] = false;
      returnData["msg"] = "오류!\n1일~31일 사이로 입력해주세요.";
    } else if (!(0 <= h && h <= 23)) {
      returnData["result"] = false;
      returnData["msg"] = "오류!\n0시~23시 사이로 입력해주세요.";
    } else if (!(0 <= min && min <= 59)) {
      returnData["result"] = false;
      returnData["msg"] = "오류!\n0분~59분 사이로 입력해주세요.";
    } else if (res <= 0) {
      returnData["result"] = false;
      returnData["msg"] = "오류!\n현재시간보다 2분뒤에 설정해주세요.";
    }
    return returnData;
  }

  Map<String, dynamic> setTime(int y, int m, int d, int h, int min) {
    //알람 입력 제대로 됐는지 검사
    Map<String, dynamic> res = checkTime(y, m, d, h, min);
    if (res["result"] == true) {
      year = y;
      month = m;
      date = d;
      hour = h;
      minute = min;
    }
    return res;
  }

  String getTime() {
    String strM = "$month";
    String strD = "$date";
    String strH = "$hour";
    String strMin = "$minute";
    if (month! < 10) {
      strM = "0$month";
    }
    if (date! < 10) {
      strD = "0$date";
    }
    if (hour! < 10) {
      strH = "0$hour";
    }
    if (minute! < 10) {
      strMin = "0$minute";
    }
    String returnStr = "$year/$strM/$strD, $strH:$strMin";
    log(returnStr + "알람설정");
    return returnStr;
  }

  String getTimeWithHC06() {
    String returnStr = "$year,$month,$date,$hour,$minute";
    return returnStr;
  }
}
