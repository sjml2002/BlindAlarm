[2021/12/01]
- 메인페이지(main.dart) 디자인 수정
- 알람설정페이지(alarm_setting.dart) 디자인 수정

<br>
[2021/11/24]
- alarmSetting 자잘한 버그 및 UI 수정
- alarmSetting 시간 설정 inputCheck 추가
- bluetooth Connect && Disconnect 구현
- 블루투스가 연결되지 않으면 알람설정 못하게 하는 경고창 구현
- 알람설정 된 timeData String형태로 데이터 보내기 성공
    - String timeData Structure => "year,month,day,hour,minute"
- {create} library.dart: 직접 작성한 라이브러리 (도움되는 것들은 전부 여기에 작성할 것)
> (arduino) 1. 아두이노에서 받은 String timeData에 맞추어 DateTime 변수 만들기<br>
> (arduino) 2. 정해진 시간에 맞추어 소형DC모터 돌아가게<br>
> (arduino) 1,2번 합쳐서 정해진 시간을 timeData로 변경 후 알람 설정 후 프로젝트 최종 마무리 하기<br>
> (flutter) 각 페이지 디자인 조금 손보기<br>
> (option) 휴대폰에도 알람이 뜰 수 있도록 하기<br>

<br>
[2021/11/23]

- 블루투스 discovery한 장치들 화면에 표시하기 까지 완료
    => 검색된 장치들은 TextButton으로 랜더링, 누르면 이름과 주소가 알람표시 됨.
> 메인화면, 알람설정, 블루투스세팅 페이지 디자인 필요 <br>
> 검색된 블루투스를 앱과 연결하기 <br>
> 연결된 앱에 데이터 보내기 <br>

<br>
[2021/11/18]

- flutter 알람설정까지 구현 완료
> 메인화면 및 알람설정 페이지 디자인 필요 <br>
> 블루투스 연결작업 필요 <br>
