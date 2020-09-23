/*
     Vcc    D2     D1     D0
  ----------------------------
     8      7      6      5

     1      2      3      4
  ----------------------------
            D3     D4     Gnd
*/

#define LED 4

void setup() {
    pinMode(LED, OUTPUT);
}

void loop() {

  digitalWrite(LED, HIGH);
  delay(5);
  digitalWrite(LED, LOW);
  delay(995);

}
