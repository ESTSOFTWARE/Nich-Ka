class ChatMember {
  final int id;
  final String name;
  final String role;
  final String? avatar;

  const ChatMember({
    required this.id,
    required this.name,
    required this.role,
    this.avatar,
  });
}
