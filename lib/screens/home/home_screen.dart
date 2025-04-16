import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/app_theme.dart';
import '../breathing/breathing_screen.dart';
import '../meditation/meditation_screen.dart';
import '../music/mood_music_screen.dart';
import '../settings/settings_screen.dart';
import '../sleep_sounds/sleep_sounds_screen.dart';
import 'widgets/daily_tip_card.dart';
import 'widgets/feature_card.dart';
import 'widgets/greeting_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _username = 'User';
  final List<Widget> _screens = [
    const HomeContent(),
    const SleepSoundsScreen(),
    const MeditationScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.midnightBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.softPurple,
              unselectedItemColor: AppTheme.textDim,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note_rounded),
                  label: 'Sounds',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.self_improvement_rounded),
                  label: 'Meditate',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: 24),
              const DailyTipCard(),
              const SizedBox(height: 32),
              Text(
                'Sleep Better Tonight',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  FeatureCard(
                    title: 'Sleep Sounds',
                    description: 'Ambient sounds to help you sleep',
                    icon: Icons.music_note_rounded,
                    color: AppTheme.softBlue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SleepSoundsScreen(),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    title: 'Mood Music',
                    description: 'Music based on your mood',
                    icon: Icons.mood_rounded,
                    color: AppTheme.softPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MoodMusicScreen(),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    title: 'Breathing',
                    description: 'Guided breathing exercises',
                    icon: Icons.air_rounded,
                    color: AppTheme.lavender,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BreathingScreen(),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    title: 'Meditation',
                    description: 'Guided meditation sessions',
                    icon: Icons.self_improvement_rounded,
                    color: AppTheme.softPink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MeditationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
