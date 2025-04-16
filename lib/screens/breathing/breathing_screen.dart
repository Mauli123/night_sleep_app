import 'dart:async';
import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Timer _timer;
  int _seconds = 0;
  String _phase = 'Inhale';
  bool _isActive = false;
  
  final int _inhaleSeconds = 4;
  final int _holdSeconds = 4;
  final int _exhaleSeconds = 4;
  final int _totalCycleSeconds = 12; // 4 + 4 + 4
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // Full breath cycle
    );
    
    _scaleAnimation = TweenSequence<double>([
      // Inhale - expand
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33.3,
      ),
      // Hold - maintain size
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 33.3,
      ),
      // Exhale - contract
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.5)
          .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33.3,
      ),
    ]).animate(_animationController);
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        if (_isActive) {
          _animationController.forward();
        }
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    if (_isActive) {
      _timer.cancel();
    }
    super.dispose();
  }
  
  void _startBreathing() {
    setState(() {
      _isActive = true;
      _seconds = 0;
      _phase = 'Inhale';
    });
    
    _animationController.forward();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds = (_seconds + 1) % _totalCycleSeconds;
        
        if (_seconds < _inhaleSeconds) {
          _phase = 'Inhale';
        } else if (_seconds < _inhaleSeconds + _holdSeconds) {
          _phase = 'Hold';
        } else {
          _phase = 'Exhale';
        }
      });
    });
  }
  
  void _stopBreathing() {
    setState(() {
      _isActive = false;
    });
    
    _animationController.stop();
    _timer.cancel();
  }
  
  String _getInstructionText() {
    switch (_phase) {
      case 'Inhale':
        return 'Breathe in slowly through your nose';
      case 'Hold':
        return 'Hold your breath';
      case 'Exhale':
        return 'Breathe out slowly through your mouth';
      default:
        return '';
    }
  }
  
  int _getSecondsRemaining() {
    if (_phase == 'Inhale') {
      return _inhaleSeconds - (_seconds % _inhaleSeconds);
    } else if (_phase == 'Hold') {
      return _holdSeconds - ((_seconds - _inhaleSeconds) % _holdSeconds);
    } else { // Exhale
      return _exhaleSeconds - ((_seconds - _inhaleSeconds - _holdSeconds) % _exhaleSeconds);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Breathing Exercise'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Take a moment to breathe',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Follow the animation and instructions for a calming breathing exercise',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textDim,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 220 * _scaleAnimation.value,
                          height: 220 * _scaleAnimation.value,
                          decoration: BoxDecoration(
                            color: _getPhaseColor().withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 180 * _scaleAnimation.value,
                              height: 180 * _scaleAnimation.value,
                              decoration: BoxDecoration(
                                color: _getPhaseColor().withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 140 * _scaleAnimation.value,
                                  height: 140 * _scaleAnimation.value,
                                  decoration: BoxDecoration(
                                    color: _getPhaseColor().withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                    Text(
                      _phase.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: _getPhaseColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getInstructionText(),
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (_isActive) ...[  
                      const SizedBox(height: 8),
                      Text(
                        '${_getSecondsRemaining()} seconds',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textDim,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isActive ? _stopBreathing : _startBreathing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isActive ? AppTheme.softPink : AppTheme.softPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    ),
                  ),
                  child: Text(
                    _isActive ? 'Stop' : 'Start Breathing',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getPhaseColor() {
    switch (_phase) {
      case 'Inhale':
        return AppTheme.softBlue;
      case 'Hold':
        return AppTheme.softPurple;
      case 'Exhale':
        return AppTheme.lavender;
      default:
        return AppTheme.softPurple;
    }
  }
}
