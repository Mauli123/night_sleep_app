import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../themes/app_theme.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildOnboardingPage(
                    title: 'Welcome to NightSleep',
                    description: 'Your personal companion for better sleep and relaxation.',
                    image: 'assets/images/onboarding_welcome.png',
                    color: AppTheme.softPurple,
                  ),
                  _buildOnboardingPage(
                    title: 'Soothing Sounds',
                    description: 'Listen to calming sounds that help you fall asleep faster.',
                    image: 'assets/images/onboarding_sounds.png',
                    color: AppTheme.softBlue,
                  ),
                  _buildOnboardingPage(
                    title: 'Guided Meditation',
                    description: 'Follow simple meditation sessions for mindfulness and relaxation.',
                    image: 'assets/images/onboarding_meditation.png',
                    color: AppTheme.lavender,
                  ),
                  _buildOnboardingPage(
                    title: 'Sleep Better',
                    description: 'Track your sleep patterns and get daily tips for better rest.',
                    image: 'assets/images/onboarding_sleep.png',
                    color: AppTheme.softPink,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _numPages,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppTheme.softPurple,
                      dotColor: AppTheme.textDim.withOpacity(0.3),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentPage > 0
                          ? TextButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: AppTheme.animationDuration,
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  color: AppTheme.textDim,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : const SizedBox(width: 80),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _numPages - 1) {
                            _pageController.nextPage(
                              duration: AppTheme.animationDuration,
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _completeOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.softPurple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(120, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                          ),
                        ),
                        child: Text(
                          _currentPage < _numPages - 1 ? 'Next' : 'Get Started',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_currentPage < _numPages - 1)
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppTheme.textDim,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required String image,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image placeholder (you'll need to add actual images)
          Container(
            height: 240,
            width: 240,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.nightlight_round,
                size: 100,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textDim,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
