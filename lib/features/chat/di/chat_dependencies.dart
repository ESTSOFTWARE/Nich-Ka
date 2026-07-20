import '../data/groq_api_service.dart';

class ChatDependencies {
  ChatDependencies._();

  static final GroqApiService _groqApi = GroqApiService();

  static GroqApiService get groqApi => _groqApi;
}
