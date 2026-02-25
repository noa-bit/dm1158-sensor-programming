#include <Wire.h> 
int ADXL345 = 0x53; 
float X, Y, Z;  
float X1, Y1, Z1;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  Wire.beginTransmission(ADXL345); 
  Wire.write(0x2D); 
  Wire.write(8);
  Wire.endTransmission();
}

void loop() {
  Wire.beginTransmission(ADXL345);
  Wire.write(0x32);
  Wire.endTransmission(false);
  Wire.requestFrom(ADXL345, 6, true);

  X1 = ( Wire.read() | Wire.read() << 8) / 256;
  Y1 = ( Wire.read() | Wire.read() << 8) / 256;
  Z1 = ( Wire.read() | Wire.read() << 8) / 256; 

  X = (X1*0.15) + (X*0.85); 
  Y = (Y1*0.15) + (Y*0.85);
  Z = (Z1*0.15) + (Z*0.85);

  // Unfiltered:
  //Serial.print("Unfiltered: ");
  Serial.print(X1);
  Serial.print(" ");
  Serial.print(Y1);
  Serial.print(" ");
  Serial.print(Z1);
  Serial.print(" ");
  // Filtered:
  //Serial.print("Filtered: ");
  Serial.print(X);
  Serial.print(" ");
  Serial.print(Y);
  Serial.print(" ");
  Serial.println(Z);
  delay(200);
}