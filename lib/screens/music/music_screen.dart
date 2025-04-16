import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  String? _selectedMood;
  bool _isPlaying = false;
  String? _currentPlayingTrack;
  
  final List<MoodItem> _moods = [
    MoodItem(
      name: 'Happy',
      icon: Icons.sentiment_very_satisfied,
      color: Colors.amber,
      description: 'Uplifting and joyful tunes',
    ),
    MoodItem(
      name: 'Calm',
      icon: Icons.spa,
      color: AppTheme.softBlue,
      description: 'Peaceful melodies for relaxation',
    ),
    MoodItem(
      name: 'Stressed',
      icon: Icons.psychology,
      color: AppTheme.softPurple,
      description: 'Soothing sounds to reduce stress',
    ),
    MoodItem(
      name: 'Anxious',
      icon: Icons.healing,
      color: AppTheme.lavender,
      description: 'Gentle tunes to ease anxiety',
    ),
    MoodItem(
      name: 'Tired',
      icon: Icons.bedtime,
      color: AppTheme.softPink,
      description: 'Soft lullabies to help you sleep',
    ),
    MoodItem(
      name: 'Focused',
      icon: Icons.lightbulb,
      color: Colors.teal,
      description: 'Ambient sounds for concentration',
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Mood Music'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'How are you feeling tonight?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Select your mood and we\'ll play music to match',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textDim,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _selectedMood == null
                  ? _buildMoodGrid()
                  : _buildMusicList(),
            ),
            if (_currentPlayingTrack != null) _buildNowPlayingBar(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMoodGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _moods.length,
      itemBuilder: (context, index) {
        final mood = _moods[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMood = mood.name;
            });
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: mood.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    mood.icon,
                    color: mood.color,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  mood.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    mood.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMusicList() {
    final selectedMoodItem = _moods.firstWhere((mood) => mood.name == _selectedMood);
    final tracks = _getTracksForMood(_selectedMood!);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selectedMoodItem.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  selectedMoodItem.icon,
                  color: selectedMoodItem.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$_selectedMood Music',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedMood = null;
                  });
                },
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Change Mood'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.textDim,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              final isPlaying = _currentPlayingTrack == track.title && _isPlaying;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: AppTheme.midnightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedMoodItem.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: selectedMoodItem.color,
                    ),
                  ),
                  title: Text(
                    track.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    track.artist,
                    style: TextStyle(
                      color: AppTheme.textDim,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: selectedMoodItem.color,
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_currentPlayingTrack == track.title) {
                          _isPlaying = !_isPlaying;
                        } else {
                          _currentPlayingTrack = track.title;
                          _isPlaying = true;
                        }
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildNowPlayingBar() {
    final selectedMoodItem = _moods.firstWhere((mood) => mood.name == _selectedMood);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.midnightBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selectedMoodItem.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.music_note,
              color: selectedMoodItem.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentPlayingTrack!,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Now Playing',
                  style: TextStyle(
                    color: AppTheme.textDim,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  // In a real app, this would play the previous track
                },
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: selectedMoodItem.color,
                  size: 36,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  // In a real app, this would play the next track
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Sample data
  List<MusicTrack> _getTracksForMood(String mood) {
    switch (mood) {
      case 'Happy':
        return [
          MusicTrack(title: 'Gentle Joy', artist: 'Harmony Dreams'),
          MusicTrack(title: 'Peaceful Smile', artist: 'Melody Makers'),
          MusicTrack(title: 'Soft Happiness', artist: 'Tranquil Tunes'),
          MusicTrack(title: 'Evening Delight', artist: 'Night Whispers'),
          MusicTrack(title: 'Dreamy Bliss', artist: 'Sleep Harmony'),
        ];
      case 'Calm':
        return [
          MusicTrack(title: 'Ocean Serenity', artist: 'Wave Sounds'),
          MusicTrack(title: 'Peaceful Night', artist: 'Moonlight Melody'),
          MusicTrack(title: 'Gentle Breeze', artist: 'Whisper Winds'),
          MusicTrack(title: 'Starlight Dreams', artist: 'Night Harmony'),
          MusicTrack(title: 'Quiet Moments', artist: 'Peaceful Piano'),
        ];
      case 'Stressed':
        return [
          MusicTrack(title: 'Tension Release', artist: 'Mind Soothers'),
          MusicTrack(title: 'Tranquil Waters', artist: 'Calm Stream'),
          MusicTrack(title: 'Stress Melter', artist: 'Relaxation Masters'),
          MusicTrack(title: 'Gentle Relief', artist: 'Peaceful Minds'),
          MusicTrack(title: 'Soothing Strings', artist: 'Harmony Ensemble'),
        ];
      case 'Anxious':
        return [
          MusicTrack(title: 'Anxiety Ease', artist: 'Calm Collective'),
          MusicTrack(title: 'Worry Free', artist: 'Peace Makers'),
          MusicTrack(title: 'Gentle Comfort', artist: 'Soothing Sounds'),
          MusicTrack(title: 'Safe Haven', artist: 'Tranquil Tones'),
          MusicTrack(title: 'Quiet Mind', artist: 'Stillness'),
        ];
      case 'Tired':
        return [
          MusicTrack(title: 'Sleep Deeply', artist: 'Dream Weavers'),
          MusicTrack(title: 'Bedtime Lullaby', artist: 'Night Whispers'),
          MusicTrack(title: 'Restful Night', artist: 'Slumber Sounds'),
          MusicTrack(title: 'Drowsy Dreams', artist: 'Sleep Well'),
          MusicTrack(title: 'Gentle Night', artist: 'Moonlight Sonata'),
        ];
      case 'Focused':
        return [
          MusicTrack(title: 'Deep Concentration', artist: 'Mind Focus'),
          MusicTrack(title: 'Clarity', artist: 'Thought Stream'),
          MusicTrack(title: 'Gentle Flow', artist: 'Concentration Zone'),
          MusicTrack(title: 'Ambient Study', artist: 'Focus Masters'),
          MusicTrack(title: 'Peaceful Productivity', artist: 'Mind Harmony'),
        ];
      default:
        return [];
    }
  }
}

class MoodItem {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  
  MoodItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class MusicTrack {
  final String title;
  final String artist;
  
  MusicTrack({
    required this.title,
    required this.artist,
  });
}
