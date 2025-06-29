import 'package:flutter/material.dart';

import '../../core/stores/search_champions/search_champions_store.dart';
import '../../dependencies/scoped_key.dart';
import '../common/theme.dart';

class SearchChampionsField extends StatefulWidget {
  const SearchChampionsField({
    super.key,
    required this.readOnly,
    required this.withStore,
    required this.decorationExpansion,
    required this.onTap,
  });

  factory SearchChampionsField.button({required VoidCallback onTap}) =>
      SearchChampionsField.transition(value: 0, onTap: onTap);

  factory SearchChampionsField.input() =>
      SearchChampionsField.transition(value: 1, withStore: true);

  factory SearchChampionsField.transition({
    required double value,
    bool? withStore,
    VoidCallback? onTap,
  }) {
    return SearchChampionsField(
      readOnly: value < 0.5,
      withStore: withStore ?? false,
      decorationExpansion: 1 - value,
      onTap: onTap,
    );
  }

  final bool readOnly;
  final bool withStore;
  final double decorationExpansion;
  final VoidCallback? onTap;

  @override
  State<SearchChampionsField> createState() => _SearchChampionsFieldState();
}

class _SearchChampionsFieldState extends State<SearchChampionsField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final store = widget.withStore ? context.locateScoped<SearchChampionsStore>() : null;

    return TextField(
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      autofocus: true,
      enableSuggestions: false,
      autocorrect: false,
      textAlignVertical: TextAlignVertical.center,
      controller: _controller,
      focusNode: _focusNode,
      decoration: _decoration(),
      onChanged: store?.updateQuery,
    );
  }

  InputDecoration _decoration() {
    final (border, prefixIcon, prefixConstraints, suffixConstraints) = _resolveDecorationProps();

    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixConstraints,
      hintText: 'Search champions...',
      suffixIcon: _clearButton(),
      suffixIconConstraints: suffixConstraints,
    );
  }

  (
    InputBorder border,
    Widget prefixIcon,
    BoxConstraints prefixConstraints,
    BoxConstraints suffixConstraints,
  ) _resolveDecorationProps() {
    final expansion = widget.decorationExpansion;
    final opacity = ((expansion - 0.5) * 2).clamp(0, 1).toDouble();

    final baseColor = context.appTheme.iconColorDim;
    final color = baseColor.withValues(alpha: baseColor.a * opacity);

    InputBorder border = InputBorder.none;
    Widget prefixIcon = const SizedBox.shrink();
    BoxConstraints prefixConstraints = const BoxConstraints();
    BoxConstraints suffixConstraints = const BoxConstraints.tightFor(height: 48);

    if (expansion > 0) {
      border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: color),
      );
      prefixIcon = Opacity(
        opacity: opacity,
        child: Padding(
          padding: EdgeInsets.only(left: 12 * expansion, top: 2),
          child: Icon(Icons.search, color: color),
        ),
      );
      prefixConstraints = BoxConstraints.tightFor(
        width: 36 * expansion,
        height: 24,
      );
      suffixConstraints = BoxConstraints.tightFor(height: 48 - 8 * expansion);
    }

    return (border, prefixIcon, prefixConstraints, suffixConstraints);
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

class SearchChampionsFieldHero extends StatelessWidget {
  const SearchChampionsFieldHero({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'searchChampionsField',
      flightShuttleBuilder:
          (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(
            child: SearchChampionsField.transition(value: animation.value),
          ),
        );
      },
      child: child,
    );
  }
}
