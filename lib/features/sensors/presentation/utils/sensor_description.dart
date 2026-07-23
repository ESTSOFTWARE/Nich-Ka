/// Descripción corta de cada sensor. Se muestra solo en tablet, aprovechando
/// el espacio extra de la card.
String sensorDescription(String id) {
  switch (id) {
    case 'ph':
      return 'Mide la acidez del mosto. Guía la actividad de las levaduras '
          'durante la fermentación.';
    case 'temp':
      return 'Temperatura del tanque. Clave para un desarrollo uniforme del '
          'sabor y aroma.';
    case 'alcohol':
      return 'Nivel de etanol producido. Indica el avance y la eficiencia de '
          'la fermentación.';
    case 'conductividad':
      return 'Sales y minerales disueltos. Refleja los cambios químicos del '
          'proceso.';
    case 'turbidez':
      return 'Partículas en suspensión. Señala la fase y la limpieza del '
          'líquido.';
    case 'rpm':
      return 'Velocidad del motor de agitación. Mantiene el mosto homogéneo y '
          'oxigenado.';
    default:
      return 'Lectura del sensor en tiempo real.';
  }
}
