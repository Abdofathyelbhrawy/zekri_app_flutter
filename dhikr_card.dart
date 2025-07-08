import 'package:flutter/material.dart';
import '../models/dhikr.dart';

class DhikrCard extends StatelessWidget {
  final Dhikr dhikr;
  final bool isSmallScreen;
  final VoidCallback onIncrement;
  final VoidCallback onReset;
  final bool isAutoCounting;
  final VoidCallback onToggleAutoCount;

  const DhikrCard({
    Key? key,
    required this.dhikr,
    required this.isSmallScreen,
    required this.onIncrement,
    required this.onReset,
    required this.isAutoCounting,
    required this.onToggleAutoCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              dhikr.text,
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            if (dhikr.benefit.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                dhikr.benefit,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Theme.of(context).colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: dhikr.count > 0 ? dhikr.currentCount / dhikr.count : 0,
              backgroundColor: Colors.grey[200],
              color: Theme.of(context).colorScheme.primary,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${dhikr.currentCount} / ${dhikr.count}',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Text(
                    'المصدر: ${dhikr.reference}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (dhikr.isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: onToggleAutoCount,
                  icon: Icon(isAutoCounting ? Icons.stop : Icons.play_arrow),
                  label: Text(isAutoCounting ? 'إيقاف' : 'تلقائي'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isAutoCounting
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add),
                  label: const Text('تسبيح'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('إعادة'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
