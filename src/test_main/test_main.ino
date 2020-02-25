#include <Wire.h>

void setup() {
    Wire.begin();
    Wire.beginTransmission(0x38);
    Wire.write(0x07);
    Wire.endTransmission();
    pinMode(2, OUTPUT);
    pinMode(3, OUTPUT);
    pinMode(4, OUTPUT);
    pinMode(5, OUTPUT);
    pinMode(6, OUTPUT);
    pinMode(7, OUTPUT);
    pinMode(8, OUTPUT);
    pinMode(9, OUTPUT);
    pinMode(10, OUTPUT);
    pinMode(11, OUTPUT);
    pinMode(12, OUTPUT);
    pinMode(13, OUTPUT);
}

void loop() {
    unsigned char fuse = 0;

    Wire.requestFrom(0x38,1);
    fuse = Wire.read() & 0x01;
    Wire.beginTransmission(0x38);
    if (fuse) Wire.write(0x0F);
    else Wire.write(0x07);
    Wire.endTransmission();
    digitalWrite(2, millis() & 0x80);
    digitalWrite(3, millis() & 0x80);
    digitalWrite(4, millis() & 0x80);
    digitalWrite(5, millis() & 0x80);
    digitalWrite(6, millis() & 0x80);
    digitalWrite(7, millis() & 0x80);
    digitalWrite(8, millis() & 0x80);
    digitalWrite(9, millis() & 0x80);
    digitalWrite(10, millis() & 0x80);
    digitalWrite(11, millis() & 0x80);
    digitalWrite(12, millis() & 0x80);
    digitalWrite(13, millis() & 0x80);
    delay(50);
}
