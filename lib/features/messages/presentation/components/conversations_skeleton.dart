import 'package:flutter/material.dart';
import '../../../../shared/theme/app_palette.dart';

class ConversationsSkeleton extends StatelessWidget {
  final AppPalette palette;

  const ConversationsSkeleton({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index < 4 ? 10 : 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: palette.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: palette.border,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 13,
                        width: 140,
                        decoration: BoxDecoration(
                          color: palette.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 11,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: palette.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 100,
                        decoration: BoxDecoration(
                          color: palette.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
