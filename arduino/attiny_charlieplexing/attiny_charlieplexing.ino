/*
     Vcc    D2     D1     D0
  ----------------------------
     8      7      6      5

     1      2      3      4
  ----------------------------
            D3     D4     Gnd
*/

#define TOTAL_PINS 4
#define TOTAL_STATES 12

byte pinNumber[TOTAL_PINS] = {2, 4, 1, 3};

int pinState[TOTAL_STATES][TOTAL_PINS] = {
  { -1, LOW, HIGH, -1},
  { -1, HIGH, LOW, -1},
  {HIGH, LOW, -1, -1},
  {LOW, HIGH, -1, -1},
  {HIGH, -1, LOW, -1},
  {LOW, -1, HIGH, -1},
  {HIGH, -1, -1, LOW},
  {LOW, -1, -1, HIGH},
  { -1, HIGH, -1, LOW},
  { -1, LOW, -1, HIGH},
  { -1, -1, HIGH, LOW},
  { -1, -1, LOW, HIGH},
};

int led = 0;


void setup() {

  //Using this loop is 30 bytes worse than unfolding it
  for (int f = 0; f <= TOTAL_PINS; f++) {
    pinMode(pinNumber[f], OUTPUT);
  }
}


void loop() {

  //Using this loop is 84 bytes worse than unfolding it
  for (int f = 0; f <= TOTAL_PINS; f++) {
    //    digitalWrite(pins[f], HIGH);
    //    delay(15);
    //    digitalWrite(pins[f], LOW);
    //    delay(85);
    if (pinState[led][f] == -1) {
      pinMode(pinNumber[f], INPUT);
    } else {
      pinMode(pinNumber[f], OUTPUT);
      digitalWrite(pinNumber[f], pinState[led][f]);
    }
  }

  led++;
  if (led >= TOTAL_STATES) {
    led = 0;
  }

  delay(10);

}
