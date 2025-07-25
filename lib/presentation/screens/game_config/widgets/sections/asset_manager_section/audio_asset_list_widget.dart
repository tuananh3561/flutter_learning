import 'package:flutter/material.dart';
import 'package:flutter_learning/data/models/asset_model.dart';
import 'package:flame_audio/flame_audio.dart';
import 'audio_upload_section.dart';
import 'audio_asset_card.dart';

/// Widget hiển thị danh sách các audio assets
class AudioAssetListWidget extends StatefulWidget {
  final List<AssetModel> assets;
  final Function(AssetModel) onDeleteAsset;

  const AudioAssetListWidget({
    Key? key,
    required this.assets,
    required this.onDeleteAsset,
  }) : super(key: key);

  @override
  State<AudioAssetListWidget> createState() => _AudioAssetListWidgetState();
}

class _AudioAssetListWidgetState extends State<AudioAssetListWidget> {
  String _searchQuery = '';
  List<AssetModel> _filteredAssets = [];
  String? _playingAudioId;
  bool _isPlaying = false;
  double _currentPosition = 0;
  double _duration = 1;

  @override
  void initState() {
    super.initState();
    _filteredAssets = widget.assets;
  }

  @override
  void didUpdateWidget(AudioAssetListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assets != widget.assets) {
      _filterAssets();
    }
  }

  /// Lọc assets theo từ khóa tìm kiếm
  void _filterAssets() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredAssets = widget.assets;
      });
    } else {
      final query = _searchQuery.toLowerCase();
      setState(() {
        _filteredAssets = widget.assets.where((asset) {
          return asset.name.toLowerCase().contains(query) ||
              asset.id.toLowerCase().contains(query) ||
              asset.path.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  /// Phát audio
  void _playAudio(AssetModel asset) async {
    // Dừng audio đang phát nếu có
    _stopAudio();

    setState(() {
      _playingAudioId = asset.id;
      _isPlaying = true;
      _currentPosition = 0;
      _duration = 5; // Giả sử thời lượng là 5 giây
    });

    try {
      // Phát audio từ URL
      FlameAudio.play(asset.url);

      // Giả lập việc cập nhật tiến độ phát
      for (int i = 0; i <= 50; i++) {
        if (!mounted || _playingAudioId != asset.id) break;
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          setState(() {
            _currentPosition = i / 10;
          });
        }
      }

      if (mounted && _playingAudioId == asset.id) {
        setState(() {
          _playingAudioId = null;
          _isPlaying = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _playingAudioId = null;
          _isPlaying = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể phát audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Dừng audio đang phát
  void _stopAudio() {
    if (_isPlaying) {
      setState(() {
        _playingAudioId = null;
        _isPlaying = false;
        _currentPosition = 0;
      });
      // Lưu ý: FlameAudio mới không yêu cầu clearAll khi dừng audio
      // FlameAudio.audioCache.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề và tổng số
        Row(
          children: [
            Text(
              'Danh sách Audio (${widget.assets.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            // Ô tìm kiếm
            SizedBox(
              width: 250,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterAssets();
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        AudioUploadSection(
          onUploadSuccess: (asset) {
            setState(() {
              widget.assets.add(asset);
              _filterAssets();
            });
          },
        ),
        const SizedBox(height: 16),

        // Hiển thị danh sách
        if (_filteredAssets.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Không có Audio nào',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        else
          SizedBox(
            height: 400, // Chiều cao cố định cho danh sách
            child: ListView.builder(
              itemCount: _filteredAssets.length,
              itemBuilder: (context, index) {
                final asset = _filteredAssets[index];
                final isPlaying = _playingAudioId == asset.id;
                return AudioAssetCard(
                  asset: asset,
                  isPlaying: isPlaying,
                  currentPosition: _currentPosition,
                  duration: _duration,
                  onPlay: () => _playAudio(asset),
                  onStop: _stopAudio,
                  onDelete: widget.onDeleteAsset,
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _stopAudio();
    super.dispose();
  }
}
