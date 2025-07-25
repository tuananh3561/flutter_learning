/// Data model cho Application Settings
class AppSettingsData {
  final String selectedLanguage;
  final bool backgroundMusicEnabled;
  final bool notificationEnabled;
  final String appVersion;
  final List<LanguageOption> availableLanguages;

  const AppSettingsData({
    required this.selectedLanguage,
    required this.backgroundMusicEnabled,
    required this.notificationEnabled,
    required this.appVersion,
    required this.availableLanguages,
  });

  AppSettingsData copyWith({
    String? selectedLanguage,
    bool? backgroundMusicEnabled,
    bool? notificationEnabled,
    String? appVersion,
    List<LanguageOption>? availableLanguages,
  }) {
    return AppSettingsData(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      backgroundMusicEnabled:
          backgroundMusicEnabled ?? this.backgroundMusicEnabled,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      appVersion: appVersion ?? this.appVersion,
      availableLanguages: availableLanguages ?? this.availableLanguages,
    );
  }

  /// Get current selected language option
  LanguageOption? get selectedLanguageOption {
    try {
      return availableLanguages.firstWhere(
        (lang) => lang.code == selectedLanguage,
      );
    } catch (e) {
      return null;
    }
  }

  /// Sample data with default settings
  static AppSettingsData getSampleData() {
    return AppSettingsData(
      selectedLanguage: 'vi',
      backgroundMusicEnabled: true,
      notificationEnabled: true,
      appVersion: '4.0.1.5',
      availableLanguages: LanguageOption.getAllLanguages(),
    );
  }
}

/// Language option model
class LanguageOption {
  final String code;
  final String name;
  final String flagAsset;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.flagAsset,
  });

  /// Get all available languages
  static List<LanguageOption> getAllLanguages() {
    return [
      LanguageOption(
        code: 'vi',
        name: 'Tiếng Việt',
        flagAsset: 'assets/images/parent/flag_vietnam.png',
      ),
      LanguageOption(
        code: 'en',
        name: 'Tiếng Anh',
        flagAsset: 'assets/images/parent/flag_us.png',
      ),
      LanguageOption(
        code: 'th',
        name: 'Tiếng Thái Lan',
        flagAsset: 'assets/images/parent/flag_thailand.png',
      ),
      LanguageOption(
        code: 'ms',
        name: 'Tiếng Malaysia',
        flagAsset: 'assets/images/parent/flag_malaysia.png',
      ),
    ];
  }

  /// Get language by code
  static LanguageOption? getLanguageByCode(String code) {
    try {
      return getAllLanguages().firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }
}

/// Settings section model
class SettingsSection {
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({
    required this.title,
    required this.items,
  });
}

/// Settings item model
class SettingsItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? iconAsset;
  final SettingsItemType type;
  final bool? switchValue;
  final String? dropdownValue;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSwitchChanged;

  const SettingsItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.iconAsset,
    this.type = SettingsItemType.normal,
    this.switchValue,
    this.dropdownValue,
    this.onTap,
    this.onSwitchChanged,
  });
}

/// Settings item type
enum SettingsItemType {
  normal,
  toggle,
  dropdown,
  info,
}

/// Callback types
typedef VoidCallback = void Function();
typedef ValueChanged<T> = void Function(T value);
