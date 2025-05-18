#include <ESP8266WiFi.h>

const char* ssid = "Your_SSID";
const char* password = "Your_PASSWORD";

#define IN1 D1  
#define IN2 D2
#define IN3 D3  // Define motor driver pins for Motor 2
#define IN4 D4

WiFiServer server(80);

void setup() {
  Serial.begin(115200);

  // Set motor pins as outputs
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);

  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi. IP address: ");
  Serial.println(WiFi.localIP());

  // Start the server
  server.begin();
  Serial.println("Server started");
}

void loop() {
  WiFiClient client = server.available();
  if (!client) {
    return;
  }

  // Wait for client request
  while (!client.available()) {
    delay(1);
  }

  String request = client.readStringUntil('\r');
  Serial.println(request);
  client.flush();

  // Control car based on request
  if (request.indexOf("/forward") != -1) {
    forward();
  } else if (request.indexOf("/backward") != -1) {
    backward();
  } else if (request.indexOf("/left") != -1) {
    left();
  } else if (request.indexOf("/right") != -1) {
    right();
  } else if (request.indexOf("/stop") != -1) {
    stop();
  }

  // Send HTML response
  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: text/html");
  client.println();
  client.println("<!DOCTYPE HTML>");
  client.println("<html>");
  client.println("<button onclick=\"location.href='/forward'\">Forward</button>");
  client.println("<button onclick=\"location.href='/backward'\">Backward</button>");
  client.println("<button onclick=\"location.href='/left'\">Left</button>");
  client.println("<button onclick=\"location.href='/right'\">Right</button>");
  client.println("<button onclick=\"location.href='/stop'\">Stop</button>");
  client.println("</html>");
}

void forward() {
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
}

void backward() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
}

void left() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
}

void right() {
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
}

void stop() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);
}