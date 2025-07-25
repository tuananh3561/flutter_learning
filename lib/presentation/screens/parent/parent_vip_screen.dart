import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/parent_data.dart';

/// Màn hình VIP cho phụ huynh
class ParentVipScreen extends StatefulWidget {
  final ParentVipData vipData;

  const ParentVipScreen({
    super.key,
    required this.vipData,
  });

  @override
  State<ParentVipScreen> createState() => _ParentVipScreenState();
}

class _ParentVipScreenState extends State<ParentVipScreen> {
  String _selectedPlanId = '1year'; // ID của plan được chọn mặc định

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x926px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: widget.vipData.isPurchased
            ? _buildPurchasedVipScreen(scale)
            : _buildNotPurchasedVipScreen(scale),
      ),
    );
  }

  /// Build màn hình VIP cho user đã mua
  Widget _buildPurchasedVipScreen(double scale) {
    final subscription = widget.vipData.subscription!;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24 * scale),
        child: Column(
          children: [
            SizedBox(height: 84 * scale),

            // VIP card
            Container(
              width: 380 * scale,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFAFAFAF)),
                borderRadius: BorderRadius.circular(20 * scale),
              ),
              child: Column(
                children: [
                  // Background image section
                  Container(
                    width: 380 * scale,
                    height: 132 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20 * scale)),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/parent/vip_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Free trial ribbon
                        Positioned(
                          top: 0,
                          right: 263 * scale,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFDE0808), Color(0xFFF14D58)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(9 * scale),
                                bottomRight: Radius.circular(9 * scale),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16 * scale,
                                    vertical: 8 * scale,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Học thử',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16 * scale,
                                          height: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '7',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 36 * scale,
                                          height: 1.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Ngày',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16 * scale,
                                          height: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content section
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        24 * scale, 24 * scale, 24 * scale, 30 * scale),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subscription info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subscription.plan,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                                fontSize: 32 * scale,
                                height: 1.0,
                                color: Color(0xFF00BAF1),
                              ),
                            ),
                            SizedBox(height: 8 * scale),
                            Text(
                              'Ngày hết hạn: ${subscription.formattedExpiryDate}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                fontSize: 16 * scale,
                                height: 1.5,
                                color: Color(0xFF777777),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32 * scale),

                        // Renew button
                        SizedBox(
                          width: 332 * scale,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Handle renewal
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF36BFFA),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Color(0xFF00B2FF),
                              padding:
                                  EdgeInsets.symmetric(vertical: 12 * scale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12 * scale),
                              ),
                            ),
                            child: Text(
                              'Gia hạn sử dụng',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                fontSize: 20 * scale,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 100 * scale),
          ],
        ),
      ),
    );
  }

  /// Build màn hình VIP cho user chưa mua
  Widget _buildNotPurchasedVipScreen(double scale) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scale),
            child: Column(
              children: [
                SizedBox(height: 68 * scale),

                // Header section
                Column(
                  children: [
                    Text(
                      'Mở khóa toàn bộ nội dung',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 28 * scale,
                        height: 1.286,
                        color: Color(0xFF00AAFF),
                      ),
                    ),
                    SizedBox(height: 8 * scale),
                    SizedBox(
                      width: 380 * scale,
                      height: 40 * scale,
                      child: Text(
                        'Gia nhập cộng đồng 15 triệu phụ huynh thông thái!\nGiúp con giỏi tiếng anh trước tuổi lên 10!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 16 * scale,
                          height: 1.5,
                          color: Color(0xFF61646C),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24 * scale),

                // Pricing plans
                _buildPricingPlans(scale),

                SizedBox(height: 24 * scale),

                // Features list
                _buildFeaturesList(scale),

                SizedBox(height: 24 * scale),

                // Awards section
                _buildAwardsSection(scale),
              ],
            ),
          ),

          // Bottom section with button
          _buildBottomSection(scale),
        ],
      ),
    );
  }

  /// Build pricing plans
  Widget _buildPricingPlans(double scale) {
    final plans = [
      {
        'id': '1year',
        'title': '1 năm',
        'subtitle': '7-ngày dùng thử miễn phí',
        'originalPrice': '1.354.237 đ',
        'price': '799.000 đ',
        'discount': '- 41%',
        'bestValue': true,
      },
      {
        'id': 'lifetime',
        'title': 'Trọn đời',
        'subtitle': null,
        'originalPrice': '2.798.000 đ',
        'price': '1.399.000 đ',
        'discount': '- 50%',
        'bestValue': false,
      },
      {
        'id': '6months',
        'title': '6 tháng',
        'subtitle': '7-ngày dùng thử miễn phí',
        'originalPrice': null,
        'price': '699.000đ',
        'discount': null,
        'bestValue': false,
      },
    ];

    return Column(
      children: plans.map((plan) {
        final isSelected = _selectedPlanId == plan['id'];
        final isBestValue = plan['bestValue'] as bool;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPlanId = plan['id'] as String;
            });
          },
          child: Container(
            width: 380 * scale,
            height: 99.5 * scale,
            margin: EdgeInsets.only(bottom: 12 * scale),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Color(0xFFF2F4F7),
              border: isSelected
                  ? Border.all(color: Color(0xFF00AAFF), width: 4 * scale)
                  : null,
              borderRadius: BorderRadius.circular(16 * scale),
            ),
            child: Stack(
              children: [
                // Discount badge
                if (plan['discount'] != null)
                  Positioned(
                    right: isBestValue ? 74 * scale : 88 * scale,
                    top: isBestValue ? 22.5 * scale : 37.5 * scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4 * scale, vertical: 2 * scale),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF4BA1),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                      child: Text(
                        plan['discount'] as String,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 14 * scale,
                          height: 1.429,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // Best value badge
                if (isBestValue)
                  Positioned(
                    right: -23.3 * scale,
                    top: -15 * scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8 * scale, vertical: 4 * scale),
                      decoration: BoxDecoration(
                        color: Color(0xFF00AAFF),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                      child: Text(
                        'Tốt nhất',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                          fontSize: 16 * scale,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // Content
                Padding(
                  padding: EdgeInsets.all(16 * scale),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan['title'] as String,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              fontSize: 16 * scale,
                              height: 1.5,
                              color: Color(0xFF424242),
                            ),
                          ),
                          if (plan['subtitle'] != null) ...[
                            SizedBox(height: 4 * scale),
                            Text(
                              plan['subtitle'] as String,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 16 * scale,
                                height: 1.5,
                                color: Color(0xFFA3A3A3),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Right side - Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (plan['originalPrice'] != null) ...[
                            Text(
                              plan['originalPrice'] as String,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 16 * scale,
                                height: 1.5,
                                color: Color(0xFF424242),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(height: 8 * scale),
                          ],
                          Text(
                            plan['price'] as String,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              fontSize: 24 * scale,
                              height: plan['id'] == 'lifetime' ? 1.333 : 1.167,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Build features list
  Widget _buildFeaturesList(double scale) {
    final features = VipFeature.getVipFeatures();

    return Column(
      children: features
          .map((feature) => Container(
                margin: EdgeInsets.only(bottom: 12 * scale),
                child: Row(
                  children: [
                    // Check icon
                    Container(
                      width: 24 * scale,
                      height: 24 * scale,
                      decoration: BoxDecoration(
                        color: Color(0xFF01C4F8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3301C4F8),
                            offset: Offset(0, 2.57 * scale),
                            blurRadius: 5.14 * scale,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          size: 12 * scale,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(width: 12 * scale),

                    Expanded(
                      child: Text(
                        feature.description,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 16 * scale,
                          height: 1.5,
                          color: Color(0xFF61646C),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  /// Build awards section
  Widget _buildAwardsSection(double scale) {
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF019EFF), Color(0xFF01CAFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24 * scale),
      ),
      child: Stack(
        children: [
          // Background decorations (stars)
          Positioned(
            top: 30 * scale,
            left: 50 * scale,
            child: Icon(
              Icons.star,
              size: 20 * scale,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Positioned(
            top: 80 * scale,
            right: 30 * scale,
            child: Icon(
              Icons.star,
              size: 15 * scale,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Positioned(
            bottom: 20 * scale,
            left: 30 * scale,
            child: Icon(
              Icons.star,
              size: 12 * scale,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Positioned(
            bottom: 50 * scale,
            right: 80 * scale,
            child: Icon(
              Icons.star,
              size: 18 * scale,
              color: Colors.white.withOpacity(0.3),
            ),
          ),

          // Main awards image - single image from Figma
          Center(
            child: Container(
              width: 356 * scale,
              height: 200 * scale,
              child: Image.asset(
                'assets/images/parent/vip_awards_main_image.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build bottom section with purchase button
  Widget _buildBottomSection(double scale) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 12 * scale, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, -0.5 * scale),
            blurRadius: 20 * scale,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 16 * scale),

          // Price info
          Text(
            '799.000đ/ năm sau 7 ngày dùng thử. Hủy bất kỳ lúc nào',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 14 * scale,
              height: 1.429,
              color: Color(0xFF737373),
            ),
          ),

          SizedBox(height: 12 * scale),

          // Purchase button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * scale),
            child: SizedBox(
              width: 380 * scale,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle purchase
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF36BFFA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Color(0xFF00B2FF),
                  padding: EdgeInsets.symmetric(vertical: 14 * scale),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * scale),
                  ),
                ),
                child: Text(
                  'Dùng thử với giá 0đ',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 20 * scale,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 12 * scale),

          // Terms links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Điều khoản & Chính sách',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 14 * scale,
                  height: 1.5,
                  color: Color(0xFF3393FF),
                ),
              ),
              Container(
                width: 6 * scale,
                height: 6 * scale,
                margin: EdgeInsets.symmetric(horizontal: 12 * scale),
                decoration: BoxDecoration(
                  color: Color(0xFF3393FF),
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                'Khôi phục gói mua',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 14 * scale,
                  height: 1.5,
                  color: Color(0xFF3393FF),
                ),
              ),
            ],
          ),

          SizedBox(height: 34 * scale),
        ],
      ),
    );
  }
}
