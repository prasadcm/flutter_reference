import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_suggestion/search_suggestion.dart';
import 'package:ui_components/ui_components.dart';

class SearchSuggestionOverlay extends StatelessWidget {
  const SearchSuggestionOverlay({super.key, this.onTap, this.onShowAll});

  final void Function(SearchSuggestionViewModel)? onTap;
  final VoidCallback? onShowAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SearchSuggestionBloc, SearchSuggestionState>(
      builder: (context, state) {
        if (state is SearchSuggestionLoaded &&
            state.searchSuggestion.suggestions.isNotEmpty) {
          final searchSuggestion = state.searchSuggestion;
          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: theme.cardColor,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: searchSuggestion.suggestions.length + 1,
              itemBuilder: (context, index) {
                if (index == searchSuggestion.suggestions.length) {
                  return _showAllListTile(
                    context,
                    searchSuggestion,
                    state.query,
                  );
                }
                return _showListTile(
                  context,
                  searchSuggestion.suggestions[index],
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

Widget _showListTile(BuildContext context, SearchSuggestionItemViewModel item) {
  return ListTile(
    leading: CachedIconView(
      iconUrl: item.iconUrl,
      size: 32,
      defaultIcon: IconCategory.search,
    ),
    title: Text(item.name),
    onTap: () => {},
  );
}

Widget _showAllListTile(
  BuildContext context,
  SearchSuggestionViewModel searchSuggestion,
  String query,
) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return ListTile(
    leading: const Icon(Icons.search),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Show all results (${searchSuggestion.total})',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '"$query"',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => {},
  );
}
