/*

PWM code based on:

ATtiny85 PWM - see http://www.technoblogy.com/show?2H0K
David Johnson-Davies - www.technoblogy.com - 19th February 2017
ATtiny85 @ 8 MHz (internal oscillator; BOD disabled)
CC BY 4.0
Licensed under a Creative Commons Attribution 4.0 International license:
http://creativecommons.org/licenses/by/4.0/


Pseudo-random number generator for ATTiny based on
https://forum.arduino.cc/index.php?topic=52502.0
*/

uint8_t Level[12] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};


ISR(TIM1_COMPA_vect) {
  static uint8_t first, ramp, column, bits, colbit;
  ramp = (ramp + 1) & 0x3F;           // Count from 0 to 63
  if (ramp == 0) {
    bits = 0x07;                      // All on
    column = (column + 1) & 0x03;
    first = column * 3;               // First LED in this column
    colbit = 1 << column;
  }
  if (Level[first] == ramp) bits = bits & 0x06;
  if (Level[first + 1] == ramp) bits = bits & 0x05;
  if (Level[first + 2] == ramp) bits = bits & 0x03;
  uint8_t mask = colbit - 1;
  uint8_t outputs = (bits & mask) | (bits & ~mask) << 1;
  DDRB = outputs | colbit;
  PORTB = outputs;
}

void setup() {
  // Set up Timer/Counter1 to multiplex the LEDs
  TCCR1 = 1 << CTC1 | 2 << CS10;      // Divide by 2
  GTCCR = 0;                          // No PWM
  OCR1A = 0;
  OCR1C = 250 - 1;                    // 16kHz
  TIMSK = TIMSK | 1 << OCIE1A;        // Compare Match A interrupt
}

void loop () {
  
  for (int i = 0; i < 12; i++) {
    Level[i] = 8;
  }

  //Twinkling
  if (getRandom() % 128 == 0) {
    Level[getRandom() % 12] = 16;
  }
  //Supernova
  if (getRandom() % 1024 == 0) {
    Level[getRandom() % 12] = 63;
  }

  delay(10);
}






unsigned long m_w = 1;
unsigned long m_z = 2;

unsigned long getRandom() {
  m_z = 36969L * (m_z & 65535L) + (m_z >> 16);
  m_w = 18000L * (m_w & 65535L) + (m_w >> 16);
  return (m_z << 16) + m_w;  /* 32-bit result */
}
