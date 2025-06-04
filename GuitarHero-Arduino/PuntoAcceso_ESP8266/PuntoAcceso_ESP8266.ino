#include <ESP8266WiFi.h>

// WiFi doméstico (modo STA)
const char* ssid_STA = "Jose Barquero";
const char* password_STA = "pass1234";

// WiFi punto de acceso (modo AP)
const char* ssid_AP = "ESP8266_AP";
const char* password_AP = "clave1234";

// TCP Server
WiFiServer server(3333);

// LED interno
const int led = LED_BUILTIN;

WiFiClient client;

void setup() {
  Serial.begin(9600);
  pinMode(led, OUTPUT);
  digitalWrite(led, HIGH); // LED apagado

  // Modo cliente (STA)
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

  // Modo AP
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
  // Si no hay cliente, intenta aceptarlo
  if (!client || !client.connected()) {
    client = server.available();
    if (client) {
      Serial.println("Cliente conectado (ESP32)");
      digitalWrite(led, LOW); // Encender LED
    }
  }

  // Si hay cliente conectado, leer datos
  if (client && client.connected()) {
    while (client.available()) {
      String mensaje = client.readStringUntil('\n'); // Leer hasta salto de línea
      Serial.print("Mensaje recibido: ");
      Serial.println(mensaje);
    }
  }

  // Si el cliente se desconectó
  if (client && !client.connected()) {
    Serial.println("Cliente desconectado");
    digitalWrite(led, HIGH); // Apagar LED
    client.stop();
  }
}
