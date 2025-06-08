import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:previously_searched/previously_searched.dart';
import 'package:ui_components/ui_components.dart';

class PreviouslySearchedView extends StatelessWidget {
  const PreviouslySearchedView({super.key, this.onTap});

  final void Function(PreviouslySearchedItemViewModel)? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreviouslySearchedBloc>().add(FetchPreviouslySearched());
    });
    return BlocBuilder<PreviouslySearchedBloc, PreviouslySearchedState>(
      builder: (context, state) {
        switch (state) {
          case PreviouslySearchedLoaded():
            final items = state.previouslySearched;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Previously searched',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Scrollable tile list
                SizedBox(
                  height: 50, // Reduced height
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () => onTap?.call(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outline,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CachedIconView(
                                iconUrl: item.iconUrl,
                                defaultIcon: IconCategory.search,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
