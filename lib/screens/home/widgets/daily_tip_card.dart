import 'package:flutter/material.dart';
import '../../../themes/app_theme.dart';

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key});

  String _getDailyTip() {
    // In a real app, this would rotate through a list of tips based on the date
    // For now, we'll just return a fixed tip
    final tips = [
      'Try to go to bed and wake up at the same time every day, even on weekends.',
      'Avoid caffeine and alcohol before bedtime for better sleep quality.',
      'Make your bedroom cool, dark, and quiet for optimal sleep conditions.',
      'Limit exposure to screens at least 1 hour before bedtime.',
      'Regular exercise can help you fall asleep faster and enjoy deeper sleep.',
      'Create a relaxing bedtime routine to signal to your body it\'s time to wind down.',
      'If you can\'t fall asleep after 20 minutes, get up and do something relaxing.',
      'Avoid large meals, spicy foods, and sugar before bedtime.',
      'Keep a sleep journal to track patterns and identify what helps you sleep better.',
      'Consider using white noise or nature sounds to mask disruptive noises.',
    ];
    
    // Use the day of the year to select a tip, ensuring it changes daily
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return tips[dayOfYear % tips.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.midnightBlue,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.softPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.softPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Daily Sleep Tip',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getDailyTip(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
