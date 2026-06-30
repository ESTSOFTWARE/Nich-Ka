import 'dart:convert';
import 'package:http/http.dart' as http;

const _apiKey = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
const _model = 'llama-3.1-8b-instant';
const _url = 'https://api.groq.com/openai/v1/chat/completions';

const _systemPrompt =
    'Eres Nich-KáBot, el asistente especializado de Nich-ká, una plataforma '
    'de monitoreo y optimización de fermentación de café con inteligencia artificial.\n\n'
    'REGLAS ESTRICTAS:\n'
    '- SOLO responde preguntas sobre: fermentación de café, pH, temperatura, '
    'tiempo de fermentación, perfiles de sabor, beneficio húmedo/seco, '
    'microbiología de fermentación, sensores IoT, algoritmos genéticos aplicados al café, '
    'y el uso de la plataforma Nich-ká.\n'
    '- Si el usuario saluda o pregunta algo fuera de esos temas, responde EXACTAMENTE: '
    '"Solo puedo ayudarte con temas de fermentación de café y la plataforma Nich-ká. '
    '¿Tienes alguna pregunta sobre eso?"\n'
    '- Usa Markdown en tus respuestas: **negrita** para términos clave, '
    'listas con - para pasos o puntos, párrafos cortos y claros.\n'
    '- Sé técnico, conciso y siempre responde en español.\n'
    '- No saludes, ve directo al punto.';

class GroqApiService {
  final List<Map<String, String>> _history = [
    {'role': 'system', 'content': _systemPrompt},
  ];

  Future<String> send(String userText) async {
    _history.add({'role': 'user', 'content': userText});

    final res = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({'model': _model, 'messages': _history}),
    );

    if (res.statusCode == 429) throw Exception('rate_limit');
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final content =
        (data['choices'] as List)[0]['message']['content'] as String;
    _history.add({'role': 'assistant', 'content': content});
    return content.trim();
  }

  void clearHistory() {
    _history
      ..clear()
      ..add({'role': 'system', 'content': _systemPrompt});
  }
}
