import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../class/domain/entities/class_member.dart';
import '../components/group_members_sheet.dart';
import '../components/reactions_viewer_sheet.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';
import '../components/chat_input_bar.dart';
import '../components/chat_message_bubble.dart';
import '../components/message_actions_sheet.dart';
import '../components/edit_bar.dart';
import '../components/reply_bar.dart';
import '../components/typing_indicator.dart';
import '../providers/group_chat_provider.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class GroupChatView extends StatelessWidget {
  final ChatConversation conversation;
  final int? highlightMessageId;

  const GroupChatView({
    super.key,
    required this.conversation,
    this.highlightMessageId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupChatProvider>(
      create: () => GroupChatProvider(
        conversation,
        highlightMessageId: highlightMessageId,
      ),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);

        // If user left, pop back
        if (provider.hasLeft) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.canPop() ? context.pop() : context.go('/messages');
            }
          });
        }

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              (64) * (isTablet(context) ? kTabletHeaderScale : 1.0),
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      isTablet(context) ? kTabletTextScale : 1,
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: palette.glassBackground,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    systemOverlayStyle: isDark
                        ? SystemUiOverlayStyle.light
                        : SystemUiOverlayStyle.dark,
                    automaticallyImplyLeading: false,
                    toolbarHeight:
                        (64) * (isTablet(context) ? kTabletHeaderScale : 1.0),
                    leadingWidth: 52,
                    leading: GestureDetector(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/messages'),
                      child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: palette.border),
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: palette.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),
                    title: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: provider.conversation.isGroup
                          ? () => _showMembers(context, provider, palette)
                          : () => _openOtherUserDetail(context, provider),
                      child: Row(
                        children: [
                          _buildAvatar(
                            palette,
                            provider.conversation,
                            provider.myUserId,
                            isOnline: provider.isOtherUserOnline,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  provider.conversation.displayName(
                                    provider.myUserId,
                                  ),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: palette.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  provider.conversation.isGroup
                                      ? '${provider.conversation.members.length} miembros'
                                      : provider.isOtherUserOnline
                                      ? 'En línea'
                                      : 'Desconectado',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Only show menu for groups (personal chats: just press back)
                    actions: [
                      if (provider.conversation.isGroup) ...[
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: palette.textPrimary,
                            size: 20,
                          ),
                          color: palette.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: palette.border),
                          ),
                          onSelected: (value) => _handleMenuAction(
                            context,
                            provider,
                            palette,
                            value,
                          ),
                          itemBuilder: (_) => [
                            if (provider.isCreator)
                              PopupMenuItem(
                                value: 'edit',
                                child: _menuItem(
                                  Icons.edit_outlined,
                                  'Editar grupo',
                                  palette,
                                ),
                              ),
                            PopupMenuItem(
                              value: 'leave',
                              child: _menuItem(
                                Icons.logout,
                                'Salir del grupo',
                                palette,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              // Importantes/urgentes fijados arriba (estilo WhatsApp)
              if (provider.importantMessages.isNotEmpty)
                _buildImportantBanner(context, provider, palette),
              Expanded(child: _buildMessageList(context, provider, palette)),
              // Pinned message banner
              if (provider.pinnedMessage != null)
                _buildPinnedBanner(provider, palette),
              // Typing
              if (provider.typingUsers.isNotEmpty)
                TypingIndicator(users: provider.typingUsers, palette: palette),
              // Reply bar
              if (provider.replyTarget != null)
                ReplyBar(
                  message: provider.replyTarget!,
                  palette: palette,
                  onCancel: provider.clearActionTargets,
                ),
              // Edit bar
              if (provider.editTarget != null)
                EditBar(
                  message: provider.editTarget!,
                  palette: palette,
                  onCancel: provider.clearActionTargets,
                ),
              // Input
              _buildBottomBar(context, provider, palette),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageList(
    BuildContext context,
    GroupChatProvider provider,
    AppPalette palette,
  ) {
    if (provider.loadingMessages && provider.messages.isEmpty) {
      return Center(child: CircularProgressIndicator(color: AppPalette.accent));
    }

    if (provider.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: palette.textMuted),
            const SizedBox(height: 12),
            Text(
              'Sin mensajes aún.\nSé el primero en escribir.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final msgs = provider.messages;
    return ResponsiveCenter(
      child: ListView.builder(
        controller: provider.scrollController,
        padding: EdgeInsets.fromLTRB(
          12,
          MediaQuery.of(context).padding.top + 64 + 12,
          12,
          12,
        ),
        itemCount: msgs.length,
        itemBuilder: (context, index) {
          final msg = msgs[index];
          final prev = index > 0 ? msgs[index - 1] : null;
          final next = index < msgs.length - 1 ? msgs[index + 1] : null;

          final isFirst = prev == null || prev.senderId != msg.senderId;
          final isLast = next == null || next.senderId != msg.senderId;
          final topPad = isFirst ? 10.0 : 2.0;

          return Dismissible(
            key: ValueKey('msg-${msg.id}'),
            direction: DismissDirection.startToEnd,
            dismissThresholds: const {DismissDirection.startToEnd: 0.25},
            confirmDismiss: (_) async {
              provider.setReplyTarget(msg); // deslizar → responder (sin borrar)
              return false;
            },
            background: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.reply_rounded,
                  color: AppPalette.accent,
                  size: 22,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: topPad),
              child: ChatMessageBubble(
                message: msg,
                palette: palette,
                isMe: msg.senderId == provider.myUserId,
                isFirst: isFirst,
                isLast: isLast,
                groupChat: provider.conversation.isGroup,
                myUserId: provider.myUserId,
                onLongPress: (m) => _showActions(context, provider, palette, m),
                onQuickReact: (emoji) => provider.react(msg.id, emoji),
                onShowReactions: (m) =>
                    _showReactions(context, provider, palette, m),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showActions(
    BuildContext context,
    GroupChatProvider provider,
    AppPalette palette,
    ChatMessage msg,
  ) {
    showMessageActionsSheet(
      context: context,
      message: msg,
      palette: palette,
      isMe: msg.senderId == provider.myUserId,
      canEdit: provider.canEdit(msg),
      isCreator: provider.isCreator,
      onReact: (emoji) => provider.react(msg.id, emoji),
      onReply: () => provider.setReplyTarget(msg),
      onEdit: () => provider.setEditTarget(msg),
      onDelete: () => provider.deleteMessage(msg.id),
      onPin: () => provider.pinMessage(msg.id),
      onPriority: (p) => provider.setPriority(msg.id, p),
    );
  }

  void _showReactions(
    BuildContext context,
    GroupChatProvider provider,
    AppPalette palette,
    ChatMessage msg,
  ) {
    if (msg.reactions.isEmpty) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ReactionsViewerSheet(
        reactions: msg.reactions,
        members: provider.conversation.members,
        myUserId: provider.myUserId,
        palette: palette,
        onToggle: (emoji) => provider.react(msg.id, emoji),
      ),
    );
  }

  Widget _buildImportantBanner(
    BuildContext context,
    GroupChatProvider provider,
    AppPalette palette,
  ) {
    final list = provider.importantMessages;
    final msg = list.last;
    final urgent = msg.isUrgent;
    final color = urgent ? const Color(0xFFEF4444) : const Color(0xFFFBBF24);
    return GestureDetector(
      onTap: () => provider.scrollToMessage(msg.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          border: Border(
            bottom: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              urgent
                  ? Icons.priority_high_rounded
                  : Icons.warning_amber_rounded,
              size: 15,
              color: color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.length > 1
                        ? '${urgent ? 'Urgente' : 'Importante'} · ${list.length} mensajes'
                        : (urgent ? 'Urgente' : 'Importante'),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    msg.content ??
                        (msg.attachments.isNotEmpty ? '📎 Archivo' : ''),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedBanner(GroupChatProvider provider, AppPalette palette) {
    final msg = provider.pinnedMessage!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppPalette.accent.withValues(alpha: 0.08),
        border: Border(
          top: BorderSide(color: AppPalette.accent.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.push_pin,
            size: 14,
            color: AppPalette.accent.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mensaje fijado',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.accent,
                  ),
                ),
                Text(
                  msg.content ??
                      (msg.attachments.isNotEmpty ? '📎 Archivo' : ''),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: palette.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (provider.isCreator)
            GestureDetector(
              onTap: () => provider.pinMessage(msg.id),
              child: Icon(Icons.close, size: 16, color: palette.textMuted),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    GroupChatProvider provider,
    AppPalette palette,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: palette.background,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: ChatInputBar(
        palette: palette,
        editingContent: provider.editTarget?.content,
        members: provider.conversation.isGroup
            ? provider.conversation.members
            : const [],
        myUserId: provider.myUserId,
        onSend: (text, mentions) => provider.sendText(text, mentions: mentions),
        onChanged: provider.onInputChanged,
        onImagePicked: provider.sendImage,
        onFilePicked: provider.sendFile,
        onStickerPicked: provider.sendSticker,
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    GroupChatProvider provider,
    AppPalette palette,
    String action,
  ) async {
    if (action == 'leave') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: palette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Salir del chat',
            style: GoogleFonts.poppins(
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            '¿Seguro que quieres salir de esta conversación?',
            style: GoogleFonts.poppins(
              color: palette.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(color: palette.textMuted),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Salir',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
      if (confirm == true) await provider.leaveConversation();
    } else if (action == 'edit') {
      _showEditGroupSheet(context, provider, palette);
    }
  }

  void _showEditGroupSheet(
    BuildContext context,
    GroupChatProvider provider,
    AppPalette palette,
  ) {
    final nameCtrl = TextEditingController(
      text: provider.conversation.name ?? '',
    );
    final descCtrl = TextEditingController(
      text: provider.conversation.description ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar grupo',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: palette.textPrimary,
                ),
                decoration: _inputDeco('Nombre del grupo', palette),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: palette.textPrimary,
                ),
                decoration: _inputDeco('Descripción (opcional)', palette),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await provider.updateGroup(
                    name: nameCtrl.text.trim().isEmpty
                        ? null
                        : nameCtrl.text.trim(),
                    description: descCtrl.text.trim().isEmpty
                        ? null
                        : descCtrl.text.trim(),
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppPalette.accent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Guardar',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDeco(String hint, AppPalette palette) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 14, color: palette.textMuted),
      filled: true,
      fillColor: palette.rowSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppPalette.accent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      isDense: true,
    );
  }

  void _showMembers(
    BuildContext context,
    GroupChatProvider provider,
    AppPalette palette,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => GroupMembersSheet(
        provider: provider,
        palette: palette,
        myUserId: provider.myUserId,
      ),
    );
  }

  /// Chat 1 a 1: tocar el header abre el detalle de perfil del otro usuario,
  /// igual que tocar un miembro en el sheet de un grupo.
  void _openOtherUserDetail(BuildContext context, GroupChatProvider provider) {
    final other = provider.conversation.otherMember(provider.myUserId);
    if (other == null) return;
    final initials = (other.name.isNotEmpty ? other.name[0] : '').toUpperCase();
    context.push(
      '/user-detail',
      extra: ClassMember(
        id: other.id,
        initials: initials,
        color: AppPalette.accent,
        name: other.name,
        avatar: other.avatar,
      ),
    );
  }

  Widget _buildAvatar(
    AppPalette palette,
    ChatConversation conv,
    int myUserId, {
    bool isOnline = false,
  }) {
    final avatarUrl = conv.displayAvatar(myUserId);
    final circle = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.accent.withValues(alpha: 0.15),
        border: Border.all(
          color: AppPalette.accent.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: avatarUrl != null
            ? Image.network(
                avatarUrl,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initials(palette, conv, myUserId),
              )
            : _initials(palette, conv, myUserId),
      ),
    );
    if (!isOnline || conv.isGroup) return circle;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        circle,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: const Color(0xFF4ADE80),
              shape: BoxShape.circle,
              border: Border.all(color: palette.glassBackground, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _initials(AppPalette palette, ChatConversation conv, int myUserId) {
    final name = conv.displayName(myUserId);
    return Container(
      color: AppPalette.accent.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppPalette.accent,
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String label,
    AppPalette palette, {
    Color? color,
  }) {
    final c = color ?? palette.textPrimary;
    return Row(
      children: [
        Icon(icon, size: 18, color: c),
        const SizedBox(width: 10),
        Text(label, style: GoogleFonts.poppins(fontSize: 14, color: c)),
      ],
    );
  }
}
