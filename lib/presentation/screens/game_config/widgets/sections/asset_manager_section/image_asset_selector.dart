/// Helper function để hiển thị dialog chọn hình ảnh
/// Tách riêng để tránh vấn đề null safety

import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'image_asset_selector_dialog.dart';

/// Hàm toàn cục để hiển thị dialog chọn hình ảnh
Future<AssetModel?> showImageAssetSelector(
  BuildContext context, {
  AssetModel? initialSelectedAsset,
  bool showUploadButton = true,
}) async {
  return await showDialog<AssetModel?>(
    context: context,
    builder: (context) => ImageAssetSelectorDialog(
      initialSelectedAsset: initialSelectedAsset,
      showUploadButton: showUploadButton,
    ),
  );
}
