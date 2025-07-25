/// Data model cho profile trong màn hình danh sách profile
class ProfileData {
  final String id;
  final String name;
  final String? avatarAsset;
  final String backgroundColor;
  final bool isAddProfile;
  final String birthYear;

  const ProfileData({
    required this.id,
    required this.name,
    this.avatarAsset,
    required this.backgroundColor,
    this.isAddProfile = false,
    this.birthYear = '2017', // Default birth year
  });

  /// CopyWith method
  ProfileData copyWith({
    String? id,
    String? name,
    String? avatarAsset,
    String? backgroundColor,
    bool? isAddProfile,
    String? birthYear,
  }) {
    return ProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isAddProfile: isAddProfile ?? this.isAddProfile,
      birthYear: birthYear ?? this.birthYear,
    );
  }

  /// Factory constructor để tạo profile "Thêm"
  factory ProfileData.addProfile() {
    return const ProfileData(
      id: 'add_profile',
      name: 'Thêm',
      backgroundColor: '#F2F4F7',
      isAddProfile: true,
    );
  }

  /// Sample data cho demo
  static List<ProfileData> getSampleProfiles() {
    return [
      const ProfileData(
        id: 'profile_1',
        name: 'Hải Long',
        avatarAsset: 'assets/images/profile/profile_avatar_1.png',
        backgroundColor: '#DBF1FF',
        birthYear: '2018',
      ),
      const ProfileData(
        id: 'profile_2',
        name: 'Thanh Tâm',
        avatarAsset: 'assets/images/profile/profile_avatar_2.png',
        backgroundColor: '#FFE8F3',
        birthYear: '2017',
      ),
      ProfileData.addProfile(),
    ];
  }
}
