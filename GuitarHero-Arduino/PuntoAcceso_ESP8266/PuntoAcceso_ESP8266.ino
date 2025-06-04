#include <ESP8266WiFi.h>

// 🔧 Reemplaza con los datos de tu red
const char* ssid = "Jose Barquero";
const char* password = "pass1234";

void setup() {
  Serial.begin(9600);  // Inicializa comunicación serial
  delay(100);

  Serial.println();
  Serial.println("Conectando a WiFi...");

  WiFi.begin(ssid, password);  // Inicia conexión

  // Espera hasta que se conecte
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  // Conexión exitosa
  Serial.println();
  Serial.println("¡Conectado a la red WiFi!");
  Serial.print("Dirección IP local: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  // Nada que hacer en el loop para esta prueba
}
