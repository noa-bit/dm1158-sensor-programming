import processing.net.*;

Server server;
Client client;

// For visualization
float lastX = 0;
float lastY = 0;
float lastZ = 0;

void setup() {
  size(400, 400);
 
  // Start server on port 5204
  server = new Server(this, 5204);
  println("Server started, waiting for client...");
}

// Called automatically when a client connects
void serverEvent(Server s, Client c) {
  println("Client connected: " + c.ip());
  client = c;
}

// Called automatically when client sends data
void clientEvent(Client c) {
  String line = c.readStringUntil('\n');
  if (line != null) {
    line = line.trim();
    String[] parts = line.split(" ");
   
    if (parts.length == 3) {
      try {
        lastX = float(parts[0]);
        lastY = float(parts[1]);
        lastZ = float(parts[2]);
       
        println("Received from client: X=" + lastX + " Y=" + lastY + " Z=" + lastZ);
       
      } catch (Exception e) {
        println("Error parsing data: " + line);
      }
    } else {
      println("Unexpected data: " + line);
    }
  }
}

void draw() {
  background(200*lastX, 200*lastY, 200*lastZ);
 
  // Simple visualization: X and Y control a circle
  fill(100, 150, 250);
  ellipse(200 - lastX*200, 200 + lastY*200, 50*lastZ, 50*lastZ);
 
}
