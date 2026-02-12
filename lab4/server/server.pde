import processing.serial.*;
import processing.net.*;

Serial myPort;
String serialLine;

Server server;
Client lastClient;

float alpha = 0.1; // low-pass filter
float fx = 0, fy = 0, fz = 0;
float rx = 0, ry = 0, rz = 0;

void setup() {
  size(400, 400);
  println("Available serial ports:");
  println(Serial.list());
  String portName = Serial.list()[0]; // adjust if needed
  myPort = new Serial(this, portName, 9600);
  
  server = new Server(this, 5204);
  println("Server started on port 5204, waiting for client...");
}

void draw() {
  background(220);
  
  if (myPort.available() > 0) {
    serialLine = myPort.readStringUntil('\n');
    if (serialLine != null) {
      serialLine = serialLine.trim();
      String[] parts = serialLine.split(" ");
      if (parts.length == 3) {
        try {
          float x = float(parts[0]);
          float y = float(parts[1]);
          float z = float(parts[2]);
          
          fx = alpha * x + (1 - alpha) * fx;
          fy = alpha * y + (1 - alpha) * fy;
          fz = alpha * z + (1 - alpha) * fz;
          
          if (lastClient != null) {
            lastClient.write(fx + " " + fy + " " + fz + "\n");
          }
          
          fill(100, 150, 250, 150);
          ellipse(200 + fx*50, 200 + fy*50, 20*fz, 20*fz);
          
        } catch (Exception e) {
          println("Error parsing serial line: " + serialLine);
        }
      } else {
        println("Unexpected serial data: " + serialLine);
      }
    }
  }
  fill(250, 100, 150, 150);
  ellipse(200 + rx*50, 200 + ry*50, 20*rz, 20*rz);
}

void serverEvent(Server s, Client c) {
  println("Client connected: " + c.ip());
  lastClient = c;
}


void clientEvent(Client c) {
  String line = c.readStringUntil('\n');
  if (line != null) {
    line = line.trim();
    String[] parts = line.split(" ");
    if (parts.length == 3) {
      try {
        rx = float(parts[0]);
        ry = float(parts[1]);
        rz = float(parts[2]);
        println("Received from client: X=" + rx + " Y=" + ry + " Z=" + rz);
      } catch (Exception e) {
        println("Error parsing received data: " + line);
      }
    } else {
      println("Unexpected received data: " + line);
    }
  }
}
