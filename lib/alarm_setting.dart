import 'dart:developer';

import 'package:flutter/material.dart';

class AlarmSetting extends StatelessWidget {
  var AlarmData = AlarmDataDTO();

  final TextEditingController _yearControl = TextEditingController();
  final TextEditingController _monthControl = TextEditingController();
  final TextEditingController _dateControl = TextEditingController();
  final TextEditingController _hourControl = TextEditingController();
  final TextEditingController _minuteControl = TextEditingController();

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
    bool result =
        AlarmData.setTime(yearData, monthData, dateData, hourData, minuteData);
    if (result) {
      AlarmData.getTime(); //DEBUG
      Navigator.pop(context, AlarmData.getTime());
    } else {
      log("시간 잘못 설정됨");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("알람 설정 오류"),
              content: const Text(
                  "시간이 잘못 설정되었습니다. 다시 설정해주십시오.\n (현재시각보다 2분뒤에 설정해주시기 바랍니다.)"),
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("알람 설정"),
        ),
        body: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _yearControl,
              ),
            ),
            const Text("년 "),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _monthControl,
              ),
            ),
            const Text("월 "),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _dateControl,
              ),
            ),
            const Text("일 "),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _hourControl,
              ),
            ),
            const Text("시 "),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _minuteControl,
              ),
            ),
            const Text("분 "),
            //send TimeData
            IconButton(
                //sending button
                icon: const Icon(Icons.send),
                onPressed: () => {sendTimeData(context)}),
          ],
        ));
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

  bool setTime(int y, int m, int d, int h, int min) {
    //현재시각 보다 더 이후에 알람시간이 맞춰져야함
    DateTime dataTmp = DateTime(y, m, d, h, min);
    int res = timeCompare(DateTime.now(), dataTmp);
    log(res.toString());
    if (res > 0) {
      year = y;
      month = m;
      date = d;
      hour = h;
      minute = min;
      return true;
    } else {
      return false;
    }
  }

  String getTime() {
    String returnData = "$year년 $month월 $date일, $hour시 $minute분";
    log(returnData + "알람설정");
    return returnData;
  }
}
