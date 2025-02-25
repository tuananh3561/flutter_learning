import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/enums/game_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Audio settings
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 0.7;
  double _musicVolume = 0.5;

  // Gameplay settings
  bool _autoCallUno = false;
  bool _highlightPlayableCards = true;

  // Rule variants
  bool _stackingDrawEnabled = false;
  bool _forcePlayEnabled = false;
  bool _jumpInEnabled = false;

  // Visual settings
  bool _showHints = true;
  bool _enableAnimations = true;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Audio settings
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _musicEnabled = prefs.getBool('musicEnabled') ?? true;
      _soundVolume = prefs.getDouble('soundVolume') ?? 0.7;
      _musicVolume = prefs.getDouble('musicVolume') ?? 0.5;

      // Gameplay settings
      _autoCallUno = prefs.getBool('autoCallUno') ?? false;
      _highlightPlayableCards = prefs.getBool('highlightPlayableCards') ?? true;

      // Rule variants
      _stackingDrawEnabled = prefs.getBool('stackingDrawEnabled') ?? false;
      _forcePlayEnabled = prefs.getBool('forcePlayEnabled') ?? false;
      _jumpInEnabled = prefs.getBool('jumpInEnabled') ?? false;

      // Visual settings
      _showHints = prefs.getBool('showHints') ?? true;
      _enableAnimations = prefs.getBool('enableAnimations') ?? true;

      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Audio settings
    await prefs.setBool('soundEnabled', _soundEnabled);
    await prefs.setBool('musicEnabled', _musicEnabled);
    await prefs.setDouble('soundVolume', _soundVolume);
    await prefs.setDouble('musicVolume', _musicVolume);

    // Gameplay settings
    await prefs.setBool('autoCallUno', _autoCallUno);
    await prefs.setBool('highlightPlayableCards', _highlightPlayableCards);

    // Rule variants
    await prefs.setBool('stackingDrawEnabled', _stackingDrawEnabled);
    await prefs.setBool('forcePlayEnabled', _forcePlayEnabled);
    await prefs.setBool('jumpInEnabled', _jumpInEnabled);

    // Visual settings
    await prefs.setBool('showHints', _showHints);
    await prefs.setBool('enableAnimations', _enableAnimations);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Audio Settings'),
            _buildSwitchSetting(
              title: 'Sound Effects',
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
              },
            ),
            if (_soundEnabled)
              _buildSliderSetting(
                title: 'Sound Volume',
                value: _soundVolume,
                onChanged: (value) {
                  setState(() {
                    _soundVolume = value;
                  });
                },
              ),
            _buildSwitchSetting(
              title: 'Background Music',
              value: _musicEnabled,
              onChanged: (value) {
                setState(() {
                  _musicEnabled = value;
                });
              },
            ),
            if (_musicEnabled)
              _buildSliderSetting(
                title: 'Music Volume',
                value: _musicVolume,
                onChanged: (value) {
                  setState(() {
                    _musicVolume = value;
                  });
                },
              ),
            const SizedBox(height: 16),
            _buildSectionHeader('Gameplay Settings'),
            _buildSwitchSetting(
              title: 'Auto-Call UNO',
              subtitle: 'Automatically call UNO when you have one card left',
              value: _autoCallUno,
              onChanged: (value) {
                setState(() {
                  _autoCallUno = value;
                });
              },
            ),
            _buildSwitchSetting(
              title: 'Highlight Playable Cards',
              subtitle: 'Highlight cards that can be played on your turn',
              value: _highlightPlayableCards,
              onChanged: (value) {
                setState(() {
                  _highlightPlayableCards = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Rule Variants'),
            _buildRuleVariantSetting(
              title: 'Stacking Draw Cards',
              subtitle: 'Allow stacking +2 on +2 and +4 on +4',
              icon: Icons.library_add,
              value: _stackingDrawEnabled,
              onChanged: (value) {
                setState(() {
                  _stackingDrawEnabled = value;
                });
              },
            ),
            _buildRuleVariantSetting(
              title: 'Force Play',
              subtitle: 'Must play a card if possible instead of drawing',
              icon: Icons.gavel,
              value: _forcePlayEnabled,
              onChanged: (value) {
                setState(() {
                  _forcePlayEnabled = value;
                });
              },
            ),
            _buildRuleVariantSetting(
              title: 'Jump-In',
              subtitle: 'Play identical cards out of turn',
              icon: Icons.front_hand,
              value: _jumpInEnabled,
              onChanged: (value) {
                setState(() {
                  _jumpInEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Visual Settings'),
            _buildSwitchSetting(
              title: 'Show Hints',
              subtitle: 'Display helpful tips during gameplay',
              value: _showHints,
              onChanged: (value) {
                setState(() {
                  _showHints = value;
                });
              },
            ),
            _buildSwitchSetting(
              title: 'Enable Animations',
              subtitle: 'Show card animations during gameplay',
              value: _enableAnimations,
              onChanged: (value) {
                setState(() {
                  _enableAnimations = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                _resetSettings();
              },
              child: const Text('Reset to Defaults'),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'UNO Game v1.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade700,
            ),
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.indigo,
      ),
      onTap: () {
        onChanged(!value);
      },
    );
  }

  Widget _buildSliderSetting({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.volume_down,
                size: 20,
                color: Colors.grey.shade600,
              ),
              Expanded(
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.indigo,
                ),
              ),
              Icon(
                Icons.volume_up,
                size: 20,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRuleVariantSetting({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        secondary: Icon(
          icon,
          color: value ? Colors.green : Colors.grey,
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
            'Are you sure you want to reset all settings to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Reset to defaults
                _soundEnabled = true;
                _musicEnabled = true;
                _soundVolume = 0.7;
                _musicVolume = 0.5;
                _autoCallUno = false;
                _highlightPlayableCards = true;
                _stackingDrawEnabled = false;
                _forcePlayEnabled = false;
                _jumpInEnabled = false;
                _showHints = true;
                _enableAnimations = true;
              });

              Navigator.of(context).pop();
              _saveSettings();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
