#include <SoftwareSerial.h>

#define BT_RXD 8
#define BT_TXD 7
SoftwareSerial blt(BT_TXD, BT_RXD);
/* 아두이노에서 코딩할때는 HC-06과 TX와 RX를 반대로 넣어야 한다.
   (아두이노 입력 -> 블루투스 출력, 블루투스 입력 -> 아두이노 출력)
*/

String inputString = "";
bool stringComplete = false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  blt.begin(9600);
  inputString.reserve(200);
  Serial.println("\n블루투스 연결 시작");
}
 
void loop() {
  // put your main code here, to run repeatedly:
  if (blt.available()) {
    Serial.write(blt.read());
  }
  if (stringComplete) {
    //여기 안됨
    if (inputString.equals("hello?")) {
      Serial.println("HRLLO WORLD!");
    }
    else {
      Serial.println(inputString);
    }
    inputString = "";
    stringComplete = false;
  }
}

//serial Event 처리 함수
void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    inputString += inChar;
    String HI = "hello?";
    if (inputString.equals(HI)) {
      Serial.println("HELLO WROLD!");
    }

    if (inChar == '\n') {
      inputString += '\n';
      stringComplete = true;
    }
  }
}
