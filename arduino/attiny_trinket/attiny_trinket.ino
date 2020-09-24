/*
     Vcc    D2     D1     D0
  ----------------------------
     8      7      6      5

     1      2      3      4
  ----------------------------
            D3     D4     Gnd
*/

byte pins[5] = {0, 2, 4, 1, 3};


void setup() {
  
  //Using this loop is 30 bytes worse than unfolding it
  for (int f = 0; f < 5; f++) {
    pinMode(pins[f], OUTPUT);
  }
}


void loop() {

  //Using this loop is 84 bytes worse than unfolding it
  for (int f = 0; f < 5; f++) {
    digitalWrite(pins[f], HIGH);
    delay(15);
    digitalWrite(pins[f], LOW);
    delay(85);
  }

  delay(1500);

}
