#include <WiFi.h>

// Credenciales del AP del ESP8266
const char* ssid = "ESP8266_AP";
const char* password = "clave1234";

// IP del ESP8266 como AP (por defecto suele ser esta)
const char* host = "192.168.4.1";
const uint16_t port = 3333;

WiFiClient client;

void setup() {
  Serial.begin(9600);
  delay(100);

  Serial.println("Conectando al AP del ESP8266...");
  WiFi.begin(ssid, password);

  // Espera conexión al AP
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
  // No hacemos nada aún, solo mantener la conexión
}
