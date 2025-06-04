#include <WiFi.h>

// Credenciales del AP del ESP8266
const char* ssid = "ESP8266_AP";
const char* password = "clave1234";

// IP del ESP8266 como AP
const char* host = "192.168.4.1";
const uint16_t port = 3333;

WiFiClient client;

// Pin del botón
const int boton = 18;
bool estadoAnterior = HIGH;

void setup() {
  Serial.begin(9600);
  pinMode(boton, INPUT_PULLUP); // Usar resistencia interna

  Serial.println("Conectando al AP del ESP8266...");
  WiFi.begin(ssid, password);

  // Esperar conexión al AP
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConectado al AP del ESP8266");
  Serial.print("Dirección IP asignada: ");
  Serial.println(WiFi.localIP());

  // Intentar conectar al servidor TCP
  Serial.print("Conectando al servidor TCP ");
  Serial.print(host);
  Serial.print(":");
  Serial.println(port);

  if (client.connect(host, port)) {
    Serial.println("Conexión TCP exitosa");
  } else {
    Serial.println("Error al conectar al servidor TCP");
  }
}

void loop() {
  if (client.connected()) {
    bool estado = digitalRead(boton);

    if (estado == LOW && estadoAnterior == HIGH) {
      Serial.println("Botón presionado → Enviando mensaje al ESP8266");
      client.println("JUGADA_SOLICITADA"); // Mensaje al ESP8266
      delay(300); // Antirrebote básico
    }

    estadoAnterior = estado;
  } else {
    Serial.println("Conexión TCP perdida");
    // Opcional: reconectar automáticamente
  }

  delay(10);
}
