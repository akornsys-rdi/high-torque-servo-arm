#include <Servo.h>
#include <Wire.h>
#include <Adafruit_ADS1015.h>

// I/O PINS
// REVISAR!!
#define THUMB_PIN 2 
#define INDEX_PIN 3
#define MIDDLE_PIN 4
#define RING_PIN 5
#define PINKY_PIN 6
#define SHOULDER_X1_PIN 7
#define SHOULDER_X2_PIN 9
#define SHOULDER_Y_PIN 8
#define ELBOW_PIN 12
#define WRIST_PIN 11
#define AUX1_PIN 10
#define AUX2_PIN 13
#define REMOTE_DTC_PIN A2
#define RING_ADC_PIN A0
#define MIDDLE_ADC_PIN A1
#define PINKY_ADC_PIN A3
#define INDEX_ADC_PIN A6
#define THUMB_ADC_PIN A7
#define WRIST_ADC_CH 0
#define ELBOW_ADC_CH 1
#define SHOULDER_X_ADC_CH 2
#define SHOULDER_Y_ADC_CH 3

// I²C ADDRESSES
#define MAIN_EXPANDER 0x38
#define REMOTE_EXPANDER 0x3F
#define REMOTE_ADC 0x48

// TRAVEL RANGE
#define MIN_SERVO 580
#define HOME_SERVO 1530
#define MAX_SERVO 2400

Servo thumb;
Servo index;
Servo middle;
Servo ring;
Servo pinky;
Servo shoulder_x1;
Servo shoulder_x2;
Servo shoulder_y;
Servo elbow;
Servo wrist;
Servo aux1;
Servo aux2;
Adafruit_ADS1015 remote_adc;

void setup() {
    pinMode(REMOTE_DTC_PIN, INPUT_PULLUP);
    Serial.begin(9600);
    if (!digitalRead(REMOTE_DTC_PIN)) Serial.println("Remote detectado!");
    Wire.begin();
    Wire.beginTransmission(MAIN_EXPANDER);
    Wire.write(0x07);
    Wire.endTransmission();
    Wire.beginTransmission(REMOTE_EXPANDER);
    Wire.write(0x07);
    Wire.endTransmission();
    remote_adc.begin();
    thumb.attach(THUMB_PIN);
    index.attach(INDEX_PIN);
    middle.attach(MIDDLE_PIN);
    ring.attach(RING_PIN);
    pinky.attach(PINKY_PIN);
    shoulder_x1.attach(SHOULDER_X1_PIN);
    shoulder_x2.attach(SHOULDER_X2_PIN);
    shoulder_y.attach(SHOULDER_Y_PIN);
    elbow.attach(ELBOW_PIN);
    wrist.attach(WRIST_PIN);
    aux1.attach(AUX1_PIN);
    aux2.attach(AUX2_PIN);
    shoulder_x2.writeMicroseconds(HOME_SERVO);
    shoulder_y.writeMicroseconds(HOME_SERVO);
}

void loop() {
    char shoulder_x_step = 0;
    char shoulder_y_step = 0;
    unsigned int joy_shoulder_x = 0;
    unsigned int joy_shoulder_y = 0;
    static unsigned int shoulder_x_pos = HOME_SERVO;
    static unsigned int shoulder_y_pos = HOME_SERVO;

    joy_shoulder_x = remote_adc.readADC_SingleEnded(SHOULDER_X_ADC_CH);
    joy_shoulder_y = remote_adc.readADC_SingleEnded(SHOULDER_Y_ADC_CH);
    if ((joy_shoulder_x > 934) && (joy_shoulder_x < 1456)) {
        shoulder_x_step = -10;
    }
    else if (joy_shoulder_x > 1456) {
        shoulder_x_step = -50;
    }
    else if ((joy_shoulder_x > 202) && (joy_shoulder_x < 734)) {
        shoulder_x_step = 10;
    }
    else if (joy_shoulder_x < 202) {
        shoulder_x_step = 50;
    }
    else shoulder_x_step = 0;
    if ((joy_shoulder_y > 934) && (joy_shoulder_y < 1456)) {
        shoulder_y_step = -10;
    }
    else if (joy_shoulder_y > 1456) {
        shoulder_y_step = -50;
    }
    else if ((joy_shoulder_y > 202) && (joy_shoulder_y < 734)) {
        shoulder_y_step = 10;
    }
    else if (joy_shoulder_y < 202) {
        shoulder_y_step = 50;
    }
    else shoulder_y_step = 0;

    shoulder_x_pos += shoulder_x_step;
    shoulder_x_pos = constrain(shoulder_x_pos, MIN_SERVO, MAX_SERVO);
    shoulder_x2.writeMicroseconds(shoulder_x_pos);
    shoulder_y_pos += shoulder_y_step;
    shoulder_y_pos = constrain(shoulder_y_pos, MIN_SERVO, MAX_SERVO);
    shoulder_y.writeMicroseconds(shoulder_y_pos);
    //aux1.writeMicroseconds(shoulder_y_pos);
    Serial.print("X: ");
    Serial.print(shoulder_x_pos);
    Serial.print("   Y: ");
    Serial.println(shoulder_y_pos);
    delay(50);
    
    /*unsigned char fuse = 0;
    unsigned char c = 0;
    unsigned char push_mode = 0;
    unsigned char push_home = 0;

    Wire.requestFrom(MAIN_EXPANDER,1);
    fuse = Wire.read() & 0x01;
    Wire.beginTransmission(MAIN_EXPANDER);
    if (fuse) Wire.write(0x0F);
    else Wire.write(0x07);
    Wire.endTransmission();
    Wire.requestFrom(REMOTE_EXPANDER,1);
    c = Wire.read() & 0x07;
    push_mode = !(c & 0x02);
    push_home = !(c & 0x04);
    if (push_mode) Serial.println("MODE");
    if (push_home) Serial.println("HOME");
    Serial.print("PINKY: ");
    Serial.println(analogRead(PINKY_ADC_PIN));
    Serial.print("RING: ");
    Serial.println(analogRead(RING_ADC_PIN));
    Serial.print("MIDDLE: ");
    Serial.println(analogRead(MIDDLE_ADC_PIN));
    Serial.print("INDEX: ");
    Serial.println(analogRead(INDEX_ADC_PIN));
    Serial.print("THUMB: ");
    Serial.println(analogRead(THUMB_ADC_PIN));
    Serial.print("WRIST: ");
    Serial.println(remote_adc.readADC_SingleEnded(WRIST_ADC_CH));
    Serial.print("ELBOW: ");
    Serial.println(remote_adc.readADC_SingleEnded(ELBOW_ADC_CH));
    Serial.print("SHOULDER X: ");
    Serial.println(remote_adc.readADC_SingleEnded(SHOULDER_X_ADC_CH));
    Serial.print("SHOULDER Y: ");
    Serial.println(remote_adc.readADC_SingleEnded(SHOULDER_Y_ADC_CH));
    Serial.println("\n");
    delay(500);*/   
}
