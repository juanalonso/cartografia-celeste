/*
     Vcc    D2     D1     D0
  ----------------------------
     8      7      6      5

     1      2      3      4
  ----------------------------
            D3     D4     Gnd
*/

void setup() {
  
  //Using this loop is 30 bytes worse than unfolding it
  for (int f = 0; f < 5; f++) {
    pinMode(f, OUTPUT);
  }
}

void loop() {

  //Using this loop is 84 bytes worse than unfolding it
  for (int f = 0; f < 5; f++) {
    digitalWrite(f, HIGH);
    delay(5);
    digitalWrite(f, LOW);
    delay(495);
  }

}
