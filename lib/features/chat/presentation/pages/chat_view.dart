import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_message_type.dart';
import '../../../../shared/theme/app_palette.dart';
import '../components/chat_ai_bubble.dart';
import '../components/chat_input_bar.dart';
import '../components/chat_recommendation_bubble.dart';
import '../components/chat_suggestion_chips.dart';
import '../components/chat_user_bubble.dart';
import '../providers/chat_provider.dart';
import '../../../home/presentation/components/home_glow.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatProvider>(
      create: () => ChatProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);

        if (provider.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.error!),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
            provider.clearError();
          });
        }

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: provider.isScrolled ? 20 : 0,
                  sigmaY: provider.isScrolled ? 20 : 0,
                ),
                child: AppBar(
                  backgroundColor: provider.isScrolled
                      ? palette.glassBackground
                      : Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  systemOverlayStyle: isDark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  leadingWidth: 56,
                  leading: Center(
                    child: GestureDetector(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/assistant'),
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(left: 16),
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
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asistente Nich-Ka',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      Text(
                        'IA en tiempo real',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    if (provider.messages.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: palette.textMuted,
                          size: 20,
                        ),
                        onPressed: provider.clearChat,
                        tooltip: 'Limpiar chat',
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'ACTIVO',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              HomeGlow(palette: palette),
              Column(
                children: [
                  Expanded(
                    child: provider.messages.isEmpty && !provider.isLoading
                      ? _buildEmptyState(palette)
                      : ListView.builder(
                          controller: provider.scrollController,
                          padding: EdgeInsets.fromLTRB(
                            16,
                            MediaQuery.of(context).padding.top +
                                kToolbarHeight +
                                8,
                            16,
                            16,
                          ),
                          itemCount: provider.messages.length +
                              (provider.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (provider.isLoading &&
                                index == provider.messages.length) {
                              return _buildTypingIndicator(palette);
                            }
                            final msg = provider.messages[index];
                            final isUser = msg.type == ChatMessageType.user;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  _buildBubble(msg, palette),
                                  const SizedBox(height: 4),
                                  Text(
                                    msg.time,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: palette.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      10,
                      16,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    decoration: BoxDecoration(
                      color: palette.background,
                      border: Border(top: BorderSide(color: palette.border)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChatSuggestionChips(
                          chips: provider.suggestions,
                          palette: palette,
                          onTap: provider.sendMessage,
                        ),
                        const SizedBox(height: 8),
                        ChatInputBar(
                          palette: palette,
                          isLoading: provider.isLoading,
                          onSend: provider.sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppPalette palette) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppPalette.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppPalette.accent,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Asistente Nich-Ka',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pregúntame sobre fermentación de café, perfiles de sabor, sensores o el uso de la plataforma.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: palette.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(delay: 0),
                const SizedBox(width: 4),
                _Dot(delay: 200),
                const SizedBox(width: 4),
                _Dot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage message, AppPalette palette) {
    return switch (message.type) {
      ChatMessageType.ai => ChatAiBubble(message: message, palette: palette),
      ChatMessageType.user => ChatUserBubble(
        message: message,
        palette: palette,
      ),
      ChatMessageType.recommendation => ChatRecommendationBubble(
        message: message,
        palette: palette,
      ),
    };
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: AppPalette.accent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
