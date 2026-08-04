import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../components/conversations_list.dart';
import '../components/conversations_skeleton.dart';
import '../components/empty_conversations_state.dart';
import '../components/messages_app_bar.dart';
import '../components/messages_error_state.dart';
import '../components/messages_search_bar.dart';
import '../components/new_conversation_sheet.dart';
import '../notifiers/messages_notifier.dart';
import '../notifiers/messages_state.dart';
import '../providers/messages_ui_state.dart';
import '../../../../core/presentation/responsive_center.dart';

class MessagesView extends ConsumerWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(messagesProvider);
    final notifier = ref.read(messagesProvider.notifier);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);

    final subtitle = switch (state.uiState) {
      MessagesUiState.loading => 'Cargando...',
      MessagesUiState.error => 'Error al cargar',
      MessagesUiState.empty => 'Sin conversaciones',
      MessagesUiState.success =>
        '${state.totalConversations} chats · ${state.totalUnread} sin leer',
    };

    return Scaffold(
      backgroundColor: palette.background,
      extendBodyBehindAppBar: true,
      appBar: MessagesAppBar(
        subtitle: subtitle,
        isScrolled: state.isScrolled,
        isDark: isDark,
        palette: palette,
        onBack: () => context.canPop() ? context.pop() : context.go('/home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _openNewConversationSheet(context, state, notifier, palette),
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
            onRefresh: notifier.refresh,
            child: ResponsiveCenter(
              child: CustomScrollView(
                controller: notifier.scrollController,
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
                        controller: notifier.searchController,
                        onChanged: notifier.setSearch,
                        palette: palette,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    sliver: SliverToBoxAdapter(
                      child: _buildContent(context, state, notifier, palette),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MessagesState state,
    MessagesNotifier notifier,
    AppPalette palette,
  ) {
    return switch (state.uiState) {
      MessagesUiState.loading => ConversationsSkeleton(palette: palette),
      MessagesUiState.error => MessagesErrorState(
        message: state.error,
        onRetry: notifier.refresh,
        palette: palette,
      ),
      _ when state.conversations.isEmpty => EmptyConversationsState(
        palette: palette,
      ),
      _ => ConversationsList(
        conversations: state.conversations,
        palette: palette,
        onlineUserIds: state.onlineUserIds,
        onTap: (c) async {
          notifier.markReadLocally(c.id);
          await context.push('/group-chat', extra: c);
          // Al volver, limpia cualquier no leído acumulado dentro del chat.
          notifier.markReadLocally(c.id);
        },
      ),
    };
  }

  Future<void> _openNewConversationSheet(
    BuildContext context,
    MessagesState state,
    MessagesNotifier notifier,
    AppPalette palette,
  ) async {
    await notifier.loadContacts();
    if (!context.mounted) return;
    final conv = await showNewConversationSheet(
      context: context,
      palette: palette,
      contacts: state.contacts,
      onCreate: ({required type, required memberIds, name}) => notifier
          .createConversation(type: type, memberIds: memberIds, name: name),
    );
    if (conv != null && context.mounted) {
      context.push('/group-chat', extra: conv);
    }
  }
}
