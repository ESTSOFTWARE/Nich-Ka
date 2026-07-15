class AssistantState {
  final List<String> suggestions;

  const AssistantState({
    this.suggestions = const [
      '¿Cómo va mi fermentación F-024?',
      'Predicción de perfil de sabor',
      'Comparar con fermentación anterior',
      '¿Cuándo termina mi fermentación?',
    ],
  });
}
