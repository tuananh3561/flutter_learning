/// Data models cho VIP status và pricing plans
enum VipStatus {
  notPurchased,
  purchased,
}

class ParentVipData {
  final VipStatus status;
  final VipSubscription? subscription;
  final List<VipPlan> availablePlans;

  const ParentVipData({
    required this.status,
    this.subscription,
    this.availablePlans = const [],
  });

  bool get isPurchased => status == VipStatus.purchased;

  /// Sample data cho VIP chưa mua
  static ParentVipData getNotPurchasedData() {
    return ParentVipData(
      status: VipStatus.notPurchased,
      availablePlans: VipPlan.getAvailablePlans(),
    );
  }

  /// Sample data cho VIP đã mua
  static ParentVipData getPurchasedData() {
    return ParentVipData(
      status: VipStatus.purchased,
      subscription: VipSubscription.getSampleSubscription(),
    );
  }
}

class VipSubscription {
  final String plan;
  final DateTime expiryDate;
  final DateTime startDate;
  final double price;
  final String currency;

  const VipSubscription({
    required this.plan,
    required this.expiryDate,
    required this.startDate,
    required this.price,
    this.currency = 'VND',
  });

  /// Kiểm tra subscription có còn active không
  bool get isActive => DateTime.now().isBefore(expiryDate);

  /// Số ngày còn lại
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(expiryDate)) return 0;
    return expiryDate.difference(now).inDays;
  }

  /// Format expiry date
  String get formattedExpiryDate {
    return '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
  }

  static VipSubscription getSampleSubscription() {
    return VipSubscription(
      plan: 'Monkey Stories',
      expiryDate: DateTime(2023, 12, 1),
      startDate: DateTime(2023, 1, 1),
      price: 799000,
    );
  }
}

class VipPlan {
  final String id;
  final String name;
  final String duration;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercentage;
  final String currency;
  final bool isBestValue;
  final bool hasTrialPeriod;
  final int trialDays;
  final List<String> features;

  const VipPlan({
    required this.id,
    required this.name,
    required this.duration,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    this.currency = 'VND',
    this.isBestValue = false,
    this.hasTrialPeriod = false,
    this.trialDays = 0,
    this.features = const [],
  });

  /// Format price theo định dạng Việt Nam
  String get formattedOriginalPrice {
    return '${originalPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} đ';
  }

  String get formattedDiscountedPrice {
    return '${discountedPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} đ';
  }

  static List<VipPlan> getAvailablePlans() {
    return [
      const VipPlan(
        id: '1_year',
        name: '1 năm',
        duration: '1 năm',
        originalPrice: 1354237,
        discountedPrice: 799000,
        discountPercentage: 41,
        isBestValue: true,
        hasTrialPeriod: true,
        trialDays: 7,
        features: [
          '6500+ hoạt động truyện tranh, thơ, bài hát, trò chơi tương tác vui nhộn',
          'Hoạt động cập nhật mới mỗi tuần',
          'Nội dung phù hợp với từng giai đoạn phát triển của trẻ',
        ],
      ),
      const VipPlan(
        id: 'lifetime',
        name: 'Trọn đời',
        duration: 'Trọn đời',
        originalPrice: 2798000,
        discountedPrice: 1399000,
        discountPercentage: 50,
        features: [
          '6500+ hoạt động truyện tranh, thơ, bài hát, trò chơi tương tác vui nhộn',
          'Hoạt động cập nhật mới mỗi tuần',
          'Nội dung phù hợp với từng giai đoạn phát triển của trẻ',
        ],
      ),
      const VipPlan(
        id: '6_months',
        name: '6 tháng',
        duration: '6 tháng',
        originalPrice: 699000,
        discountedPrice: 699000,
        discountPercentage: 0,
        hasTrialPeriod: true,
        trialDays: 7,
        features: [
          '6500+ hoạt động truyện tranh, thơ, bài hát, trò chơi tương tác vui nhộn',
          'Hoạt động cập nhật mới mỗi tuần',
          'Nội dung phù hợp với từng giai đoạn phát triển của trẻ',
        ],
      ),
    ];
  }
}

class VipFeature {
  final String icon;
  final String title;
  final String description;

  const VipFeature({
    required this.icon,
    required this.title,
    required this.description,
  });

  static List<VipFeature> getVipFeatures() {
    return const [
      VipFeature(
        icon: '✓',
        title: '6500+ hoạt động',
        description: 'Truyện tranh, thơ, bài hát, trò chơi tương tác vui nhộn',
      ),
      VipFeature(
        icon: '✓',
        title: 'Cập nhật hàng tuần',
        description: 'Hoạt động cập nhật mới mỗi tuần',
      ),
      VipFeature(
        icon: '✓',
        title: 'Phù hợp từng giai đoạn',
        description: 'Nội dung phù hợp với từng giai đoạn phát triển của trẻ',
      ),
    ];
  }
}
