import processing.serial.*; // Bibliotek
import processing.net.*;
Serial myPort;
String serialLine;

String serverIP = "130.229.129.19"; // KOLLA HÄR!
int serverPort = 5204;
Client clientNode;

float fx = 0, fy = 0, fz = 0;
float rx = 0, ry = 0, rz = 0;

void setup() {
  size(400, 400);
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);
  clientNode = new Client(this, serverIP, serverPort);
  println("Connecting to server " + serverIP + ":" + serverPort);
}

void draw() {
  background(220);
  if (clientNode == null || !clientNode.active()) {
    delay(1000);
    println("Trying to reconnect to server...");
    clientNode = new Client(this, serverIP, serverPort);
    return;
  }
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
          
          clientNode.write(x + " " + y + " " + z + "\n");
          
        } catch (Exception e) {
          println("Error parsing serial line: " + serialLine);
        }
      } else {
        println("Unexpected serial data: " + serialLine);
      }
    }
  }
  
while (clientNode.available() > 0) {
  String line = clientNode.readStringUntil('\n');
  if (line != null) {
    line = line.trim();
    String[] parts = line.split(" ");
    if (parts.length == 3) {
      try {
        rx = float(parts[0]);
        ry = float(parts[1]);
        rz = float(parts[2]);
        println("Received from server: X=" + rx + " Y=" + ry + " Z=" + rz);
      } catch (Exception e) {
        println("Error parsing received data: " + line);
      }
    } else {
      println("Unexpected received data: " + line);
    }
  }
}
  fill(200*rx, 200*ry, 200*rz);
  ellipse(200 - rx*200, 200 + ry*200, 50*rz, 50*rz);
}
