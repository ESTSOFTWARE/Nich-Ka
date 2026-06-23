import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../domain/entities/chat_conversation.dart';
import '../components/conversation_card.dart';
import '../components/conversations_skeleton.dart';
import '../components/empty_conversations_state.dart';
import '../components/new_conversation_sheet.dart';
import '../providers/messages_provider.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MessagesProvider>(
      create: () => MessagesProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);

        final subtitle = provider.state == MessagesUiState.success
            ? '${provider.totalConversations} chats · ${provider.totalUnread} sin leer'
            : 'Cargando...';

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(64),
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
                  toolbarHeight: 64,
                  leadingWidth: 56,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GestureDetector(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/home'),
                      child: Container(
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
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mensajes',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                _openNewConversationSheet(context, provider, palette),
            backgroundColor: AppPalette.accent,
            elevation: 4,
            child: const Icon(Icons.edit_outlined, color: Colors.black),
          ),
          body: Stack(
            children: [
              HomeGlow(palette: palette),
              RefreshIndicator(
                color: AppPalette.accent,
                backgroundColor: palette.surface,
                onRefresh: provider.refresh,
                child: CustomScrollView(
                  controller: provider.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        MediaQuery.of(context).padding.top + 64 + 12,
                        16,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildSearchBar(provider, palette),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                      sliver: SliverToBoxAdapter(
                        child: _buildContent(context, provider, palette),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(MessagesProvider provider, AppPalette palette) {
    return TextField(
      controller: _searchCtrl,
      onChanged: provider.setSearch,
      style: GoogleFonts.poppins(fontSize: 14, color: palette.textPrimary),
      decoration: InputDecoration(
        hintText: 'Buscar conversación...',
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: palette.textMuted),
        prefixIcon: Icon(Icons.search, color: palette.textMuted, size: 20),
        suffixIcon: _searchCtrl.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, color: palette.textMuted, size: 18),
                onPressed: () {
                  _searchCtrl.clear();
                  provider.setSearch('');
                },
              )
            : null,
        filled: true,
        fillColor: palette.surface,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        isDense: true,
      ),
    );
  }

  Future<void> _openNewConversationSheet(
    BuildContext context,
    MessagesProvider provider,
    AppPalette palette,
  ) async {
    await provider.loadContacts();
    if (!context.mounted) return;
    final conv = await showNewConversationSheet(
      context: context,
      palette: palette,
      contacts: provider.contacts,
      onCreate: ({required type, required memberIds, name}) => provider
          .createConversation(type: type, memberIds: memberIds, name: name),
    );
    if (conv != null && context.mounted) {
      context.push('/group-chat', extra: conv);
    }
  }

  Widget _buildContent(
    BuildContext context,
    MessagesProvider provider,
    AppPalette palette,
  ) {
    if (provider.state == MessagesUiState.loading) {
      return ConversationsSkeleton(palette: palette);
    }
    if (provider.state == MessagesUiState.error) {
      return _buildError(palette, provider);
    }
    if (provider.conversations.isEmpty) {
      return EmptyConversationsState(palette: palette);
    }
    return _buildList(context, provider, provider.conversations, palette);
  }

  Widget _buildList(
    BuildContext context,
    MessagesProvider provider,
    List<ChatConversation> convs,
    AppPalette palette,
  ) {
    return Column(
      children: convs.map((c) {
        final isLast = c == convs.last;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
          child: ConversationCard(
            conversation: c,
            myUserId: HttpClient.instance.userId,
            palette: palette,
            onTap: () {
              provider.markReadLocally(c.id);
              context.push('/group-chat', extra: c);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildError(AppPalette palette, MessagesProvider provider) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: palette.textMuted),
            const SizedBox(height: 12),
            Text(
              provider.error ?? 'Error al cargar mensajes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: provider.refresh,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppPalette.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppPalette.accent.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.accent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
