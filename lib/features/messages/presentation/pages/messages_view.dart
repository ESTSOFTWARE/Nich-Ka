import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../components/conversations_list.dart';
import '../components/conversations_skeleton.dart';
import '../components/empty_conversations_state.dart';
import '../components/messages_app_bar.dart';
import '../components/messages_error_state.dart';
import '../components/messages_search_bar.dart';
import '../components/new_conversation_sheet.dart';
import '../providers/messages_provider.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MessagesProvider>(
      create: () => MessagesProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);

        final subtitle = switch (provider.state) {
          MessagesUiState.loading => 'Cargando...',
          MessagesUiState.error => 'Error al cargar',
          MessagesUiState.empty => 'Sin conversaciones',
          MessagesUiState.success =>
            '${provider.totalConversations} chats · ${provider.totalUnread} sin leer',
        };

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: MessagesAppBar(
            subtitle: subtitle,
            isScrolled: provider.isScrolled,
            isDark: isDark,
            palette: palette,
            onBack: () =>
                context.canPop() ? context.pop() : context.go('/home'),
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
                        child: MessagesSearchBar(
                          controller: provider.searchController,
                          onChanged: provider.setSearch,
                          palette: palette,
                        ),
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

  Widget _buildContent(
    BuildContext context,
    MessagesProvider provider,
    AppPalette palette,
  ) {
    return switch (provider.state) {
      MessagesUiState.loading => ConversationsSkeleton(palette: palette),
      MessagesUiState.error => MessagesErrorState(
        message: provider.error,
        onRetry: provider.refresh,
        palette: palette,
      ),
      _ when provider.conversations.isEmpty => EmptyConversationsState(
        palette: palette,
      ),
      _ => ConversationsList(
        conversations: provider.conversations,
        palette: palette,
        onTap: (c) async {
          provider.markReadLocally(c.id);
          await context.push('/group-chat', extra: c);
          // Al volver, limpia cualquier no leído acumulado dentro del chat.
          provider.markReadLocally(c.id);
        },
      ),
    };
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
}
