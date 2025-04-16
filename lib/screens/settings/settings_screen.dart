import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay _bedtimeReminder = const TimeOfDay(hour: 22, minute: 0); // 10:00 PM default
  bool _enableNotifications = true;
  bool _enableDarkMode = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('username') ?? 'User';
      _enableNotifications = prefs.getBool('enableNotifications') ?? true;
      _enableDarkMode = prefs.getBool('enableDarkMode') ?? true;
      
      // Load bedtime reminder time
      final hour = prefs.getInt('bedtimeHour') ?? 22;
      final minute = prefs.getInt('bedtimeMinute') ?? 0;
      _bedtimeReminder = TimeOfDay(hour: hour, minute: minute);
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _nameController.text);
    await prefs.setBool('enableNotifications', _enableNotifications);
    await prefs.setBool('enableDarkMode', _enableDarkMode);
    await prefs.setInt('bedtimeHour', _bedtimeReminder.hour);
    await prefs.setInt('bedtimeMinute', _bedtimeReminder.minute);
    
    // Update notifications if enabled
    if (_enableNotifications) {
      _scheduleBedtimeReminder();
    } else {
      _cancelBedtimeReminder();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings saved')),
    );
  }
  
  Future<void> _scheduleBedtimeReminder() async {
    // In a real app, this would schedule a notification using flutter_local_notifications
    // For now, we'll just print the scheduled time
    print('Scheduled bedtime reminder for ${_bedtimeReminder.format(context)}');
  }
  
  Future<void> _cancelBedtimeReminder() async {
    // In a real app, this would cancel the notification
    print('Cancelled bedtime reminder');
  }
  
  Future<void> _selectBedtimeReminder() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _bedtimeReminder,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppTheme.midnightBlue,
              hourMinuteTextColor: AppTheme.textLight,
              dayPeriodTextColor: AppTheme.textLight,
              dialHandColor: AppTheme.softPurple,
              dialBackgroundColor: AppTheme.deepNavy,
              dialTextColor: AppTheme.textLight,
              entryModeIconColor: AppTheme.softPurple,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.softPurple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _bedtimeReminder) {
      setState(() {
        _bedtimeReminder = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildSectionHeader('Profile'),
            Card(
              color: AppTheme.midnightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppTheme.softPurple.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: AppTheme.softPurple,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppTheme.softPurple,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(color: AppTheme.textDim),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppTheme.textDim.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppTheme.softPurple),
                        ),
                      ),
                      style: TextStyle(color: AppTheme.textLight),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            _buildSectionHeader('Notifications'),
            Card(
              color: AppTheme.midnightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    subtitle: Text(
                      'Receive bedtime reminders',
                      style: TextStyle(color: AppTheme.textDim),
                    ),
                    value: _enableNotifications,
                    onChanged: (value) {
                      setState(() {
                        _enableNotifications = value;
                      });
                    },
                    activeColor: AppTheme.softPurple,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Bedtime Reminder'),
                    subtitle: Text(
                      'Daily at ${_bedtimeReminder.format(context)}',
                      style: TextStyle(color: AppTheme.textDim),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.textDim,
                    ),
                    enabled: _enableNotifications,
                    onTap: _enableNotifications ? _selectBedtimeReminder : null,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Settings Section
            _buildSectionHeader('App Settings'),
            Card(
              color: AppTheme.midnightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: Text(
                      'Use dark theme for better sleep',
                      style: TextStyle(color: AppTheme.textDim),
                    ),
                    value: _enableDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _enableDarkMode = value;
                      });
                    },
                    activeColor: AppTheme.softPurple,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('About NightSleep'),
                    subtitle: Text(
                      'Version 1.0.0',
                      style: TextStyle(color: AppTheme.textDim),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.textDim,
                    ),
                    onTap: () {
                      // Show about dialog
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.softPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.softPurple,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
