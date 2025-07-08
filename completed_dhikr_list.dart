import 'package:flutter/material.dart';
import '../models/dhikr.dart';

class CompletedDhikrList extends StatelessWidget {
  final List<Dhikr> completedAdhkar;
  final bool isSmallScreen;

  const CompletedDhikrList({
    super.key,
    required this.completedAdhkar,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    if (completedAdhkar.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'الأذكار المكتملة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.blueGrey[800],
              fontSize: isSmallScreen ? 18 : 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        ...completedAdhkar.map(
          (dhikr) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.blueGrey[50]?.withOpacity(0.9),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              leading: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
              title: Text(
                dhikr.text,
                style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: isSmallScreen ? 14 : 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${dhikr.count} مرة - ${dhikr.reference}',
                style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
