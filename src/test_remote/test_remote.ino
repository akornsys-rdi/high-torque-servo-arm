#include <Wire.h>
#include <Adafruit_ADS1015.h>

// 0x3F I/O EXPANDER - 0x48 ADC

Adafruit_ADS1015 adc;

void setup() {
    Wire.begin();
    Wire.beginTransmission(0x3F);
    Wire.write(0x07);
    Wire.endTransmission();
    pinMode(A2, INPUT_PULLUP);
    pinMode(A4, INPUT_PULLUP);
    pinMode(A5, INPUT_PULLUP);
    adc.begin();
    Serial.begin(9600);
    if (!digitalRead(A2)) Serial.println("Remote detectado!");
}

void loop() {
    unsigned char c = 0;
    unsigned char push_mode = 0;
    unsigned char push_home = 0;

    Wire.requestFrom(0x3F,1);
    c = Wire.read() & 0x07;
    push_mode = !(c & 0x02);
    push_home = !(c & 0x04);
    if (push_mode) Serial.println("MODE");
    if (push_home) Serial.println("HOME");
    Serial.print("PINKY: ");
    Serial.println(analogRead(A3));
    Serial.print("RING: ");
    Serial.println(analogRead(A0));
    Serial.print("MIDDLE: ");
    Serial.println(analogRead(A1));
    Serial.print("INDEX: ");
    Serial.println(analogRead(A6));
    Serial.print("THUMB: ");
    Serial.println(analogRead(A7));
    Serial.print("WRIST: ");
    Serial.println(adc.readADC_SingleEnded(0));
    Serial.print("ELBOW: ");
    Serial.println(adc.readADC_SingleEnded(1));
    Serial.print("SHOULDER X: ");
    Serial.println(adc.readADC_SingleEnded(2));
    Serial.print("SHOULDER Y: ");
    Serial.println(adc.readADC_SingleEnded(3));
    Serial.println("\n");
    delay(500);
}
