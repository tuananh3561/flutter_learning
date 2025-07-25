// Import all parent data models
import 'parent_report_data.dart';
import 'parent_vip_data.dart';
import 'parent_settings_data.dart';

// Export all parent data models
export 'parent_report_data.dart';
export 'parent_vip_data.dart';
export 'parent_settings_data.dart';

/// Enum cho các tab trong parent settings
enum ParentTab {
  report,
  vip,
  settings,
}

/// Data model tổng hợp cho parent settings
class ParentData {
  final ParentReportData reportData;
  final ParentVipData vipData;
  final ParentSettingsData settingsData;
  final ParentTab currentTab;

  const ParentData({
    required this.reportData,
    required this.vipData,
    required this.settingsData,
    this.currentTab = ParentTab.report,
  });

  /// Copy with method để update current tab
  ParentData copyWith({
    ParentReportData? reportData,
    ParentVipData? vipData,
    ParentSettingsData? settingsData,
    ParentTab? currentTab,
  }) {
    return ParentData(
      reportData: reportData ?? this.reportData,
      vipData: vipData ?? this.vipData,
      settingsData: settingsData ?? this.settingsData,
      currentTab: currentTab ?? this.currentTab,
    );
  }

  /// Sample data với VIP chưa mua
  static ParentData getSampleData() {
    return ParentData(
      reportData: ParentReportData.getSampleData(),
      vipData: ParentVipData.getNotPurchasedData(),
      settingsData: ParentSettingsData.getSampleData(),
      currentTab: ParentTab.report,
    );
  }

  /// Sample data với VIP đã mua
  static ParentData getSampleDataWithVip() {
    return ParentData(
      reportData: ParentReportData.getSampleData(),
      vipData: ParentVipData.getPurchasedData(),
      settingsData: ParentSettingsData.getSampleData(),
      currentTab: ParentTab.vip,
    );
  }
}

/// Model cho profile item trong switch profile modal
class ProfileSwitchItem {
  final String id;
  final String name;
  final String joinDate;
  final String avatarAsset;
  final bool isSelected;

  ProfileSwitchItem({
    required this.id,
    required this.name,
    required this.joinDate,
    required this.avatarAsset,
    required this.isSelected,
  });

  ProfileSwitchItem copyWith({
    String? id,
    String? name,
    String? joinDate,
    String? avatarAsset,
    bool? isSelected,
  }) {
    return ProfileSwitchItem(
      id: id ?? this.id,
      name: name ?? this.name,
      joinDate: joinDate ?? this.joinDate,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
