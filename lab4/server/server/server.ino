#include <Wire.h>  // Wire library - used for I2C communication
int ADXL345 = 0x53; // The ADXL345 sensor I2C address
float XYZ[3];
float X, Y, Z;  // Outputs
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

  X1 = ( Wire.read() | Wire.read() << 8);
  Y1 = ( Wire.read() | Wire.read() << 8);
  Z1 = ( Wire.read() | Wire.read() << 8); 
  X = ((X1 / 256)*0.15) + (X*0.85); 
  Y = ((Y1 / 256)*0.15) + (Y*0.85);
  Z = ((Z1 / 256)*0.15) + (Z*0.85);
  XYZ[0] = X;
  XYZ[1] = Y;
  XYZ[2] = Z;
  Serial.print(X);
  Serial.print(" ");
  Serial.print(Y);
  Serial.print(" ");
  Serial.println(Z);
}

