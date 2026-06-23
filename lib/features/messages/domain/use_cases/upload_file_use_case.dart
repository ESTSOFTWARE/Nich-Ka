import 'dart:io';
import '../entities/message_attachment.dart';
import '../repositories/chat_repository.dart';

class UploadFileUseCase {
  final ChatRepository _repo;
  const UploadFileUseCase(this._repo);
  Future<MessageAttachment> call(File file) => _repo.uploadFile(file);
}
