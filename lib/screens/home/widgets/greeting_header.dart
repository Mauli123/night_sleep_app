import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../themes/app_theme.dart';

class GreetingHeader extends StatefulWidget {
  const GreetingHeader({super.key});

  @override
  State<GreetingHeader> createState() => _GreetingHeaderState();
}

class _GreetingHeaderState extends State<GreetingHeader> {
  String _username = 'User';
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _setGreeting();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = 'Good Morning';
    } else if (hour < 17) {
      _greeting = 'Good Afternoon';
    } else {
      _greeting = 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _greeting,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.softPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: AppTheme.softPurple,
              ),
            ),
          ],
        ),
        Text(
          _username,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'How are you feeling tonight?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textDim,
              ),
        ),
      ],
    );
  }
}
