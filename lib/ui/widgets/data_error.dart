import 'package:flutter/material.dart';

class DataError extends StatelessWidget {
  const DataError({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_outlined,
            size: 56,
            color: Colors.black38,
          ),
          const SizedBox(height: 8),
          Text(
            message,
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
      ),
    );
  }
}
