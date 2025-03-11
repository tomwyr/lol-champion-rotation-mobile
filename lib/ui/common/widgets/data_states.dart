import 'package:flutter/material.dart';

import '../theme.dart';
import 'fit_viewport_scroll_view.dart';

class DataLoading extends StatelessWidget {
  const DataLoading({
    super.key,
    this.message,
    this.expand = true,
    this.sliver = false,
  });

  final String? message;
  final bool expand;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    return _DataLayout(
      expand: expand,
      sliver: sliver,
      children: [
        const CircularProgressIndicator(),
        if (message case var message?) ...[
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ],
    );
  }
}

class DataError extends StatelessWidget {
  const DataError({
    super.key,
    required this.message,
    this.icon,
    this.onRetry,
    this.expand = true,
    this.sliver = false,
  });

  final String message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final bool expand;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    return _DataLayout(
      expand: expand,
      sliver: sliver,
      children: [
        Icon(
          icon ?? Icons.error_outline_outlined,
          size: 56,
          color: context.appTheme.iconColorDim,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Refresh'),
          ),
        ],
      ],
    );
  }
}

class DataInfo extends StatelessWidget {
  const DataInfo({
    super.key,
    required this.message,
    this.icon,
    this.expand = true,
    this.sliver = false,
  });

  final String message;
  final IconData? icon;
  final bool expand;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    return _DataLayout(
      expand: expand,
      sliver: sliver,
      children: [
        Icon(
          icon,
          size: 56,
          color: context.appTheme.iconColorDim,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _DataLayout extends StatelessWidget {
  const _DataLayout({
    required this.children,
    required this.expand,
    required this.sliver,
  });

  final List<Widget> children;
  final bool expand;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );

    if (!expand) {
      return SafeArea(
        child: content,
      );
    }

    if (sliver) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: SafeArea(
          child: content,
        ),
      );
    } else {
      return SafeArea(
        child: FitViewportScrollView(
          child: content,
        ),
      );
    }
  }
}
