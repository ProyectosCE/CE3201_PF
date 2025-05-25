#include <ESP8266WiFi.h>

// Configura el Access Point
const char* ssid = "Jose Barquero";
const char* password = "pass1234";

WiFiServer server(3333);  // Puerto TCP

void setup() {
  Serial.begin(9600); // Ajustado a 9600 baudios

  // Iniciar AP
  WiFi.softAP(ssid, password);
  Serial.println();
  Serial.print("AP iniciado: ");
  Serial.println(ssid);
  Serial.print("IP local: ");
  Serial.println(WiFi.softAPIP());

  // Inicia servidor
  server.begin();
  Serial.println("Esperando conexión del ESP32...");
}

void loop() {
  WiFiClient client = server.available();

  if (client) {
    Serial.println("ESP32 conectado.");
    while (client.connected()) {
      if (client.available()) {
        String dato = client.readStringUntil('\n');
        Serial.print("Dato recibido: ");
        Serial.println(dato);
      }
    }
    Serial.println("ESP32 desconectado.");
    client.stop();
  }
}
