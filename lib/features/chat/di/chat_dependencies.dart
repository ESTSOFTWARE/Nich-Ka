import '../data/groq_api_service.dart';

class ChatDependencies {
  ChatDependencies._();

  static GroqApiService get groqApi => GroqApiService();
}
