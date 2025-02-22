import 'package:flutter/material.dart';

import '../../core/stores/search_champions/search_champions.dart';
import '../../dependencies.dart';

class SearchChampionsField extends StatefulWidget {
  const SearchChampionsField({super.key});

  @override
  State<SearchChampionsField> createState() => _SearchChampionsFieldState();
}

class _SearchChampionsFieldState extends State<SearchChampionsField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  SearchChampionsStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      enableSuggestions: false,
      autocorrect: false,
      textAlignVertical: TextAlignVertical.center,
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: 'Champion name...',
        suffixIcon: _clearButton(),
      ),
      onChanged: store.updateQuery,
    );
  }

  Widget _clearButton() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.text.isEmpty) {
          return const SizedBox.shrink();
        }
        return IconButton(
          onPressed: () {
            _controller.text = '';
            _focusNode.requestFocus();
          },
          icon: const Icon(Icons.clear),
        );
      },
    );
  }
}
