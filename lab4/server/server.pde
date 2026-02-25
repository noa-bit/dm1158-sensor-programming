import processing.serial.*;
import processing.net.*;

Serial myPort;
String serialLine;

String serverIP = "130.229.129.7";
int serverPort = 5204;

Client clientNode;

float rx = 0, ry = 0, rz = 0;

void setup() {
  size(400, 400);

  println("Available serial ports:");
  println(join(Serial.list(), ", "));
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);

  clientNode = new Client(this, serverIP, serverPort);
  println("Connecting to server " + serverIP + ":" + serverPort);
}

void draw() {
  background(220);
  
  // --- RECONNECT IF SERVER DROPS ---
  if (clientNode == null || !clientNode.active()) {
    println("Trying to reconnect...");
    delay(1000);
    clientNode = new Client(this, serverIP, serverPort);
    return;
  }

  // --- SEND SERIAL DATA TO SERVER ---
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
          println("Sent to server: " + x + " " + y + " " + z);

        } catch (Exception e) {
          println("Error parsing serial line: " + serialLine);
        }
      }
    }
  }

  // --- VISUALIZE RECEIVED DATA ---
  fill(200 * rx, 200 * ry, 200 * rz);
  ellipse(200 + rx * 100, 200 + ry * 100, 50 * rz, 50 * rz);
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

        println("Received from server: " + rx + " " + ry + " " + rz);

      } catch (Exception e) {
        println("Error parsing server data: " + line);
      }
    }
  }
}