
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  const SummaryCard({super.key, required this.title, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('\$${amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
