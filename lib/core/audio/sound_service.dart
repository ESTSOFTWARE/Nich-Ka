import 'package:audioplayers/audioplayers.dart';

/// Reproduce los sonidos de la app (notificaciones y mensajes).
/// Los assets viven en assets/sounds/ (declarados en pubspec).
class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> _play(String file) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/$file'));
    } catch (_) {
      /* silencioso: no romper la UI por un sonido */
    }
  }

  Future<void> notification() => _play('sound_notification.mp3');
  Future<void> message() => _play('sound_message.mp3');
  Future<void> responseMessage() => _play('sound_response_message.mp3');
}

/// ID de la conversación abierta actualmente. Sirve para no reproducir
/// `sound_message` (lista) cuando ya estás dentro del chat (que suena
/// `sound_response_message`).
class ActiveChat {
  ActiveChat._();
  static int? conversationId;
}
