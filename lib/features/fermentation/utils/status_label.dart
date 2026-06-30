String statusLabelFor(String status) {
  return switch (status) {
    'scheduled' => 'Programada',
    'running' => 'En proceso',
    'completed' => 'Completada',
    'interrupted' => 'Interrumpida',
    _ => status,
  };
}
