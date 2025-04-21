import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class SleepSoundsScreen extends StatefulWidget {
  const SleepSoundsScreen({super.key});

  @override
  State<SleepSoundsScreen> createState() => _SleepSoundsScreenState();
}

class _SleepSoundsScreenState extends State<SleepSoundsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPlayingIndex = -1;
  bool _isPlaying = false;
  int _selectedTimerIndex = -1;
  final List<int> _timerOptions = [15, 30, 45, 60, 90]; // in minutes
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _togglePlayPause(int index) {
    setState(() {
      if (_currentPlayingIndex == index) {
        _isPlaying = !_isPlaying;
      } else {
        _currentPlayingIndex = index;
        _isPlaying = true;
      }
    });
    // In a real app, this would trigger audio playback
  }
  
  void _selectTimer(int index) {
    setState(() {
      if (_selectedTimerIndex == index) {
        _selectedTimerIndex = -1; // Deselect
      } else {
        _selectedTimerIndex = index;
      }
    });
    // In a real app, this would set a timer to stop playback
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Sleep Sounds'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.softPurple,
          indicatorWeight: 3,
          labelColor: AppTheme.softPurple,
          unselectedLabelColor: AppTheme.textDim,
          tabs: const [
            Tab(text: 'Nature'),
            Tab(text: 'Rain'),
            Tab(text: 'Ambient'),
            Tab(text: 'White Noise'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSoundGrid(_getNatureSounds()),
                _buildSoundGrid(_getRainSounds()),
                _buildSoundGrid(_getAmbientSounds()),
                _buildSoundGrid(_getWhiteNoiseSounds()),
              ],
            ),
          ),
          if (_currentPlayingIndex != -1) _buildNowPlayingBar(),
        ],
      ),
    );
  }
  
  Widget _buildSoundGrid(List<SoundItem> sounds) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        final sound = sounds[index];
        final isCurrentlyPlaying = _currentPlayingIndex == sound.id && _isPlaying;
        
        return GestureDetector(
          onTap: () => _togglePlayPause(sound.id),
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
                    color: sound.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCurrentlyPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: sound.color,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  sound.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildNowPlayingBar() {
    // Find the currently playing sound
    SoundItem? currentSound;
    final allSounds = [..._getNatureSounds(), ..._getRainSounds(), 
                      ..._getAmbientSounds(), ..._getWhiteNoiseSounds()];
    
    for (var sound in allSounds) {
      if (sound.id == _currentPlayingIndex) {
        currentSound = sound;
        break;
      }
    }
    
    if (currentSound == null) return const SizedBox.shrink();
    
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: currentSound.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.music_note,
                  color: currentSound.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Now Playing',
                      style: TextStyle(
                        color: AppTheme.textDim,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentSound.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: AppTheme.softPurple,
                  size: 36,
                ),
                onPressed: () => _togglePlayPause(_currentPlayingIndex),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sleep Timer',
                style: TextStyle(
                  color: AppTheme.textDim,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _timerOptions.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text('${_timerOptions[index]}m'),
                          selected: _selectedTimerIndex == index,
                          selectedColor: AppTheme.softPurple,
                          backgroundColor: AppTheme.deepNavy,
                          labelStyle: TextStyle(
                            color: _selectedTimerIndex == index
                                ? Colors.white
                                : AppTheme.textDim,
                          ),
                          onSelected: (selected) => _selectTimer(index),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Sample data
  List<SoundItem> _getNatureSounds() {
    return [
      SoundItem(id: 0, name: 'Forest', color: AppTheme.softBlue),
      SoundItem(id: 1, name: 'Ocean Waves', color: AppTheme.softBlue),
      SoundItem(id: 2, name: 'Crickets', color: AppTheme.softBlue),
      SoundItem(id: 3, name: 'Birds', color: AppTheme.softBlue),
      SoundItem(id: 4, name: 'Stream', color: AppTheme.softBlue),
      SoundItem(id: 5, name: 'Campfire', color: AppTheme.softBlue),
    ];
  }
  
  List<SoundItem> _getRainSounds() {
    return [
      SoundItem(id: 6, name: 'Light Rain', color: AppTheme.lavender),
      SoundItem(id: 7, name: 'Heavy Rain', color: AppTheme.lavender),
      SoundItem(id: 8, name: 'Rain on Roof', color: AppTheme.lavender),
      SoundItem(id: 9, name: 'Rain on Window', color: AppTheme.lavender),
      SoundItem(id: 10, name: 'Thunderstorm', color: AppTheme.lavender),
    ];
  }
  
  List<SoundItem> _getAmbientSounds() {
    return [
      SoundItem(id: 11, name: 'Cafe', color: AppTheme.softPurple),
      SoundItem(id: 12, name: 'Fireplace', color: AppTheme.softPurple),
      SoundItem(id: 13, name: 'Wind Chimes', color: AppTheme.softPurple),
      SoundItem(id: 14, name: 'Heartbeat', color: AppTheme.softPurple),
      SoundItem(id: 15, name: 'Spaceship', color: AppTheme.softPurple),
    ];
  }
  
  List<SoundItem> _getWhiteNoiseSounds() {
    return [
      SoundItem(id: 16, name: 'White Noise', color: AppTheme.softPink),
      SoundItem(id: 17, name: 'Pink Noise', color: AppTheme.softPink),
      SoundItem(id: 18, name: 'Brown Noise', color: AppTheme.softPink),
      SoundItem(id: 19, name: 'Fan', color: AppTheme.softPink),
      SoundItem(id: 20, name: 'Air Conditioner', color: AppTheme.softPink),
    ];
  }
}

class SoundItem {
  final int id;
  final String name;
  final Color color;
  
  SoundItem({
    required this.id,
    required this.name,
    required this.color,
  });
}
