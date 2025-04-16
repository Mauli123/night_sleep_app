import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'All',
    'Sleep',
    'Stress',
    'Anxiety',
    'Focus',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Meditation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Guided Meditation',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select a session to help you relax and sleep better',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textDim,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: _selectedCategoryIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    selectedColor: AppTheme.softPurple,
                    backgroundColor: AppTheme.midnightBlue,
                    labelStyle: TextStyle(
                      color: _selectedCategoryIndex == index
                          ? Colors.white
                          : AppTheme.textDim,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getMeditationSessions().length,
              itemBuilder: (context, index) {
                final session = _getMeditationSessions()[index];
                if (_selectedCategoryIndex != 0 && 
                    session.category != _categories[_selectedCategoryIndex]) {
                  return const SizedBox.shrink();
                }
                return _buildMeditationCard(session);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMeditationCard(MeditationSession session) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          // In a real app, this would navigate to a meditation player screen
          _showMeditationDetails(session);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.midnightBlue,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: session.color.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.borderRadius),
                    topRight: Radius.circular(AppTheme.borderRadius),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.self_improvement_rounded,
                    size: 64,
                    color: session.color,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          session.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: session.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${session.durationMinutes} min',
                            style: TextStyle(
                              color: session.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      session.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textDim,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          color: session.color,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Start Session',
                          style: TextStyle(
                            color: session.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showMeditationDetails(MeditationSession session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.midnightBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    session.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: AppTheme.textDim,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                session.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: session.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.category,
                      style: TextStyle(
                        color: session.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: session.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${session.durationMinutes} minutes',
                      style: TextStyle(
                        color: session.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // In a real app, this would start the meditation session
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: session.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    ),
                  ),
                  child: const Text(
                    'Start Meditation',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
  
  // Sample data
  List<MeditationSession> _getMeditationSessions() {
    return [
      MeditationSession(
        title: 'Deep Sleep Meditation',
        description: 'A guided meditation to help you fall into a deep, restful sleep.',
        durationMinutes: 10,
        category: 'Sleep',
        color: AppTheme.softPurple,
      ),
      MeditationSession(
        title: 'Stress Relief',
        description: 'Release tension and calm your mind before bedtime.',
        durationMinutes: 8,
        category: 'Stress',
        color: AppTheme.softBlue,
      ),
      MeditationSession(
        title: 'Body Scan for Sleep',
        description: 'A progressive relaxation technique to prepare your body for sleep.',
        durationMinutes: 15,
        category: 'Sleep',
        color: AppTheme.softPurple,
      ),
      MeditationSession(
        title: 'Anxiety Calming',
        description: 'Soothe anxious thoughts and find peace before sleep.',
        durationMinutes: 12,
        category: 'Anxiety',
        color: AppTheme.lavender,
      ),
      MeditationSession(
        title: 'Mindful Breathing',
        description: 'Focus your attention on your breath to quiet the mind.',
        durationMinutes: 5,
        category: 'Focus',
        color: AppTheme.softPink,
      ),
      MeditationSession(
        title: 'Gratitude Practice',
        description: 'End your day with gratitude for better sleep and wellbeing.',
        durationMinutes: 7,
        category: 'Stress',
        color: AppTheme.softBlue,
      ),
    ];
  }
}

class MeditationSession {
  final String title;
  final String description;
  final int durationMinutes;
  final String category;
  final Color color;
  
  MeditationSession({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.category,
    required this.color,
  });
}
