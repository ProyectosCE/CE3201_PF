#include <ESP8266WiFi.h>

// WiFi doméstico (modo STA)
const char* ssid_STA = "Jose Barquero";
const char* password_STA = "pass1234";

// WiFi punto de acceso (modo AP)
const char* ssid_AP = "ESP8266_AP";
const char* password_AP = "clave1234";

// TCP Server
WiFiServer server(3333);

// LED interno (GPIO2 en NodeMCU V3)
const int led = LED_BUILTIN; // usualmente GPIO2, en NodeMCU se enciende con LOW

void setup() {
  Serial.begin(9600);
  pinMode(led, OUTPUT);
  digitalWrite(led, HIGH); // Apagado por defecto

  // Modo cliente - conectar al WiFi de casa
  WiFi.begin(ssid_STA, password_STA);
  Serial.print("Conectando a red WiFi: ");
  Serial.println(ssid_STA);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConectado a WiFi doméstico");
  Serial.print("IP local: ");
  Serial.println(WiFi.localIP());

  // Iniciar punto de acceso
  WiFi.softAP(ssid_AP, password_AP);
  Serial.print("Punto de acceso iniciado: ");
  Serial.println(ssid_AP);
  Serial.print("IP AP: ");
  Serial.println(WiFi.softAPIP());

  // Iniciar servidor TCP
  server.begin();
  Serial.println("Servidor TCP iniciado en puerto 3333");
}

void loop() {
  WiFiClient client = server.available(); // Espera cliente

  if (client) {
    Serial.println("Cliente conectado (ESP32)");
    digitalWrite(led, LOW); // Encender LED

    while (client.connected()) {
      // En este punto podrías leer datos si lo deseas
      delay(10); // evitar watchdog
    }

    Serial.println("Cliente desconectado");
    digitalWrite(led, HIGH); // Apagar LED
    client.stop();
  }
}
