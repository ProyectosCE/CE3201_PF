// Pines asignados a cada botón
const int boton1 = 18;
const int boton2 = 19;
const int boton3 = 21;

// Variables de estado
bool estado1Previo = HIGH;
bool estado2Previo = HIGH;
bool estado3Previo = HIGH;

void setup() {
  Serial.begin(115200);  // Inicializa el monitor serial

  // Configura los pines como entrada con resistencia pull-up interna
  pinMode(boton1, INPUT_PULLUP);
  pinMode(boton2, INPUT_PULLUP);
  pinMode(boton3, INPUT_PULLUP);

  Serial.println("Iniciando prueba de botones con pull-up interno...");
}

void loop() {
  // Leemos el estado de cada botón
  bool estado1 = digitalRead(boton1);
  bool estado2 = digitalRead(boton2);
  bool estado3 = digitalRead(boton3);

  // Detectamos flancos descendentes (presión del botón)
  if (estado1 == LOW && estado1Previo == HIGH) {
    Serial.println("Botón 1 presionado");
  }
  if (estado2 == LOW && estado2Previo == HIGH) {
    Serial.println("Botón 2 presionado");
  }
  if (estado3 == LOW && estado3Previo == HIGH) {
    Serial.println("Botón 3 presionado");
  }

  // Guardamos el estado actual para la próxima comparación
  estado1Previo = estado1;
  estado2Previo = estado2;
  estado3Previo = estado3;

  delay(50);  // Pequeña pausa para estabilidad
}
