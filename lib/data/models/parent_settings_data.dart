/// Data models cho parent settings options
class ParentSettingsData {
  final UserInfo userInfo;
  final List<SettingsSection> sections;

  const ParentSettingsData({
    required this.userInfo,
    required this.sections,
  });

  static ParentSettingsData getSampleData() {
    return ParentSettingsData(
      userInfo: UserInfo.getSampleUser(),
      sections: SettingsSection.getAllSections(),
    );
  }
}

class UserInfo {
  final String deviceId;
  final String userId;

  const UserInfo({
    required this.deviceId,
    required this.userId,
  });

  static UserInfo getSampleUser() {
    return const UserInfo(
      deviceId: '10062000',
      userId: '10062000',
    );
  }
}

class SettingsSection {
  final String id;
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({
    required this.id,
    required this.title,
    required this.items,
  });

  static List<SettingsSection> getAllSections() {
    return [
      SettingsSection(
        id: 'profile',
        title: 'Thông tin phụ huynh',
        items: [
          SettingsItem(
            id: 'parent_info',
            title: 'Thông tin ba mẹ',
            icon: SettingsIcon.profile,
            onTap: () => _handleParentInfo(),
          ),
          SettingsItem(
            id: 'device_id',
            title: 'ID thiết bị',
            subtitle: '10062000',
            icon: SettingsIcon.mobile,
            showArrow: false,
          ),
          SettingsItem(
            id: 'user_id',
            title: 'ID người dùng',
            subtitle: '10062000',
            icon: SettingsIcon.userCircle,
            showArrow: false,
          ),
        ],
      ),
      SettingsSection(
        id: 'management',
        title: 'Quản lý người học',
        items: [
          SettingsItem(
            id: 'learning_profile',
            title: 'Hồ sơ học tập của con',
            icon: SettingsIcon.student,
            onTap: () => _handleLearningProfile(),
          ),
          SettingsItem(
            id: 'activation_code',
            title: 'Nhập mã kích hoạt',
            icon: SettingsIcon.unlock,
            onTap: () => _handleActivationCode(),
          ),
          SettingsItem(
            id: 'change_password',
            title: 'Thay đổi mật khẩu',
            icon: SettingsIcon.password,
            onTap: () => _handleChangePassword(),
          ),
        ],
      ),
      SettingsSection(
        id: 'app_settings',
        title: 'Cài Đặt',
        items: [
          SettingsItem(
            id: 'general_settings',
            title: 'Cài đặt chung',
            icon: SettingsIcon.setting,
            onTap: () => _handleGeneralSettings(),
          ),
          SettingsItem(
            id: 'delete_data',
            title: 'Xóa dữ liệu đã tải',
            icon: SettingsIcon.trash,
            onTap: () => _handleDeleteData(),
          ),
          SettingsItem(
            id: 'schedule',
            title: 'Đặt lịch học',
            icon: SettingsIcon.alarm,
            onTap: () => _handleSchedule(),
          ),
        ],
      ),
      SettingsSection(
        id: 'support',
        title: 'Hỗ trợ',
        items: [
          SettingsItem(
            id: 'about_monkey',
            title: 'Về Monkey',
            icon: SettingsIcon.dangerCircle,
            onTap: () => _handleAboutMonkey(),
          ),
          SettingsItem(
            id: 'terms',
            title: 'Điều khoản sử dụng',
            icon: SettingsIcon.paper,
            onTap: () => _handleTerms(),
          ),
          SettingsItem(
            id: 'privacy',
            title: 'Chính sách bảo mật',
            icon: SettingsIcon.shieldDone,
            onTap: () => _handlePrivacy(),
          ),
          SettingsItem(
            id: 'faq',
            title: 'Câu hỏi thường gặp',
            icon: SettingsIcon.chat,
            onTap: () => _handleFAQ(),
          ),
          SettingsItem(
            id: 'contact',
            title: 'Liên hệ Monkey',
            icon: SettingsIcon.calling,
            onTap: () => _handleContact(),
          ),
        ],
      ),
      SettingsSection(
        id: 'logout',
        title: 'Đăng xuất',
        items: [
          SettingsItem(
            id: 'logout',
            title: 'Đăng xuất',
            icon: SettingsIcon.logout,
            onTap: () => _handleLogout(),
            isDestructive: true,
          ),
        ],
      ),
    ];
  }

  // Placeholder methods for handling actions
  static void _handleParentInfo() {
    // TODO: Navigate to parent info screen
  }

  static void _handleLearningProfile() {
    // TODO: Navigate to learning profile screen
  }

  static void _handleActivationCode() {
    // TODO: Show activation code dialog
  }

  static void _handleChangePassword() {
    // TODO: Navigate to change password screen
  }

  static void _handleGeneralSettings() {
    // TODO: Navigate to general settings screen
  }

  static void _handleDeleteData() {
    // TODO: Show delete data confirmation dialog
  }

  static void _handleSchedule() {
    // TODO: Navigate to schedule screen
  }

  static void _handleAboutMonkey() {
    // TODO: Show about monkey dialog
  }

  static void _handleTerms() {
    // TODO: Open terms of service
  }

  static void _handlePrivacy() {
    // TODO: Open privacy policy
  }

  static void _handleFAQ() {
    // TODO: Navigate to FAQ screen
  }

  static void _handleContact() {
    // TODO: Open contact options
  }

  static void _handleLogout() {
    // TODO: Show logout confirmation dialog
  }
}

class SettingsItem {
  final String id;
  final String title;
  final String? subtitle;
  final SettingsIcon icon;
  final VoidCallback? onTap;
  final bool showArrow;
  final bool isDestructive;

  const SettingsItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.showArrow = true,
    this.isDestructive = false,
  });
}

enum SettingsIcon {
  profile,
  mobile,
  userCircle,
  student,
  unlock,
  password,
  setting,
  trash,
  alarm,
  dangerCircle,
  paper,
  shieldDone,
  chat,
  calling,
  logout,
}

typedef VoidCallback = void Function();
