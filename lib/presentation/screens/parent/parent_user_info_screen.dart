import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/parent_user_info.dart';
import 'package:flutter_learning/presentation/common/app_header.dart';
import 'package:flutter_learning/presentation/common/buttom/custom_button.dart';
import 'package:flutter_learning/presentation/common/text_field/name_form.dart';
import 'package:flutter_learning/presentation/common/text_field/phone_form.dart';
import 'package:flutter_learning/presentation/common/text_field/email_form.dart';
import 'package:flutter_learning/data/models/auth_data.dart';

/// Màn hình thông tin người dùng cho parent
class ParentUserInfoScreen extends StatefulWidget {
  final ParentUserInfo userInfo;
  final Function(ParentUserInfo)? onUserInfoChanged;

  const ParentUserInfoScreen({
    super.key,
    required this.userInfo,
    this.onUserInfoChanged,
  });

  @override
  State<ParentUserInfoScreen> createState() => _ParentUserInfoScreenState();
}

class _ParentUserInfoScreenState extends State<ParentUserInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late ParentUserInfo _currentUserInfo;

  // FormFieldValidation for new form widgets
  FormFieldValidation _nameValidation =
      FormFieldValidation(state: ValidationState.valid);
  FormFieldValidation _phoneValidation =
      FormFieldValidation(state: ValidationState.valid);
  FormFieldValidation _emailValidation =
      FormFieldValidation(state: ValidationState.valid);

  @override
  void initState() {
    super.initState();
    _currentUserInfo = widget.userInfo;
    _nameController = TextEditingController(text: _currentUserInfo.name);
    _phoneController =
        TextEditingController(text: _currentUserInfo.phoneNumber);
    _emailController = TextEditingController(text: _currentUserInfo.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Handle name change
  void _onNameChanged(String value) {
    // Validate name length
    FormFieldValidation validation;
    if (value.length > 50) {
      validation = FormFieldValidation(
        state: ValidationState.invalid,
        errorMessage: 'Số ký tự vượt quá 50 ký tự',
      );
    } else {
      validation = FormFieldValidation(state: ValidationState.valid);
    }

    setState(() {
      _nameValidation = validation;
      _currentUserInfo = _currentUserInfo.copyWith(name: value);
    });

    if (widget.onUserInfoChanged != null) {
      widget.onUserInfoChanged!(_currentUserInfo);
    }
  }

  /// Handle phone change
  void _onPhoneChanged(String value) {
    setState(() {
      _phoneValidation = FormFieldValidation(state: ValidationState.valid);
      _currentUserInfo = _currentUserInfo.copyWith(phoneNumber: value);
    });

    if (widget.onUserInfoChanged != null) {
      widget.onUserInfoChanged!(_currentUserInfo);
    }
  }

  /// Handle email change
  void _onEmailChanged(String value) {
    // Validate email format
    FormFieldValidation validation;
    if (value.isNotEmpty && !_isValidEmail(value)) {
      validation = FormFieldValidation(
        state: ValidationState.invalid,
        errorMessage: 'Email không hợp lệ',
      );
    } else {
      validation = FormFieldValidation(state: ValidationState.valid);
    }

    setState(() {
      _emailValidation = validation;
      _currentUserInfo = _currentUserInfo.copyWith(email: value);
    });

    if (widget.onUserInfoChanged != null) {
      widget.onUserInfoChanged!(_currentUserInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive scaling dựa trên kích thước Figma 428x926px
    final scale =
        math.min(size.width / 428.0, size.height / 926.0).clamp(0.8, 1.8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header using AppHeader
            AppHeader(
              title: 'Thông tin ba mẹ',
              scaleFactor: scale,
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  child: Column(
                    children: [
                      SizedBox(height: 32 * scale),

                      // Name field label
                      _buildFieldLabel(scale, 'Họ và tên:', Color(0xFF92C73D)),
                      SizedBox(height: 8 * scale),

                      // Name field using NameForm
                      NameForm(
                        controller: _nameController,
                        onChanged: _onNameChanged,
                        validation: _nameValidation,
                        scaleFactor: scale,
                        hintText: 'Nhập họ và tên',
                      ),

                      SizedBox(height: 24 * scale),

                      // Phone field label
                      _buildFieldLabel(
                          scale, 'Số điện thoại:', Color(0xFFFFB61C)),
                      SizedBox(height: 8 * scale),

                      // Phone field using PhoneForm
                      PhoneForm(
                        controller: _phoneController,
                        onChanged: _onPhoneChanged,
                        validation: _phoneValidation,
                        scaleFactor: scale,
                        hintText: '+84 123 456 789',
                      ),

                      SizedBox(height: 24 * scale),

                      // Email field label
                      _buildFieldLabel(scale, 'Email:', Color(0xFF68AFFF)),
                      SizedBox(height: 8 * scale),

                      // Email field using EmailForm
                      EmailForm(
                        controller: _emailController,
                        onChanged: _onEmailChanged,
                        validation: _emailValidation,
                        scaleFactor: scale,
                        hintText: 'abc@gmail.com',
                      ),

                      SizedBox(height: 48 * scale),
                    ],
                  ),
                ),
              ),
            ),

            // Save button using CustomButton
            Padding(
              padding: EdgeInsets.fromLTRB(
                  24 * scale, 12 * scale, 24 * scale, 34 * scale),
              child: CustomButton(
                text: 'Lưu',
                onPressed: () {
                  // TODO: Handle save action
                  Navigator.pop(context);
                },
                type: ButtonType.primary,
                size: ButtonSize.xl,
                customScale: scale,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build field label với icon
  Widget _buildFieldLabel(double scale, String label, Color iconColor) {
    return Row(
      children: [
        // Icon
        Container(
          width: 24 * scale,
          height: 24 * scale,
          child: Icon(
            label.contains('tên')
                ? Icons.person_outline
                : label.contains('điện thoại')
                    ? Icons.phone_outlined
                    : Icons.email_outlined,
            size: 18 * scale,
            color: iconColor,
          ),
        ),

        SizedBox(width: 8 * scale),

        // Label text
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 16 * scale,
            color: Color(0xFF6F6F6F),
          ),
        ),
      ],
    );
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
