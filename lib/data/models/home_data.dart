/// Data model cho màn hình Home
/// Hỗ trợ 4 tab: Truyện, Video, Sách nói, Lộ trình
class HomeData {
  final List<HomeTab> tabs;
  final List<StoryItem> stories;
  final List<VideoItem> videos;
  final List<AudiobookItem> audiobooks;
  final int activeTabIndex;
  final bool isVipUnlocked;

  const HomeData({
    required this.tabs,
    required this.stories,
    required this.videos,
    required this.audiobooks,
    this.activeTabIndex = 0,
    this.isVipUnlocked = false,
  });

  HomeData copyWith({
    List<HomeTab>? tabs,
    List<StoryItem>? stories,
    List<VideoItem>? videos,
    List<AudiobookItem>? audiobooks,
    int? activeTabIndex,
    bool? isVipUnlocked,
  }) {
    return HomeData(
      tabs: tabs ?? this.tabs,
      stories: stories ?? this.stories,
      videos: videos ?? this.videos,
      audiobooks: audiobooks ?? this.audiobooks,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      isVipUnlocked: isVipUnlocked ?? this.isVipUnlocked,
    );
  }
}

/// Tab types cho home screen
enum HomeTabType {
  story('Truyện', 'assets/images/home/book_icon.svg'),
  video('Video', 'assets/images/home/video_icon.svg'),
  audiobook('Sách nói', 'assets/images/home/audiobook_icon.svg'),
  lesson('Lộ trình', 'assets/images/home/lesson_icon.svg');

  const HomeTabType(this.title, this.iconPath);

  final String title;
  final String iconPath;
}

/// Model cho mỗi tab
class HomeTab {
  final HomeTabType type;
  final bool isActive;
  final int itemCount;

  const HomeTab({
    required this.type,
    required this.isActive,
    this.itemCount = 0,
  });

  HomeTab copyWith({
    HomeTabType? type,
    bool? isActive,
    int? itemCount,
  }) {
    return HomeTab(
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}

/// Story item type (Free, VIP, VIP Overlay)
enum StoryItemType {
  free,
  vip,
  vipOverlay,
}

/// Model cho mỗi story item
class StoryItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final StoryItemType type;
  final String letter; // A, B, C, D etc.
  final bool isFavorite;
  final String? backgroundColor; // hex color

  const StoryItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.type,
    required this.letter,
    this.isFavorite = false,
    this.backgroundColor,
  });

  StoryItem copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    StoryItemType? type,
    String? letter,
    bool? isFavorite,
    String? backgroundColor,
  }) {
    return StoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      letter: letter ?? this.letter,
      isFavorite: isFavorite ?? this.isFavorite,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

/// Video item type (Free, VIP Overlay)
enum VideoItemType {
  free,
  vipOverlay,
}

/// Model cho mỗi video item
class VideoItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final VideoItemType type;
  final String duration; // "12:30"
  final bool isFavorite;
  final String? backgroundColor; // hex color

  const VideoItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.type,
    required this.duration,
    this.isFavorite = false,
    this.backgroundColor,
  });

  VideoItem copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    VideoItemType? type,
    String? duration,
    bool? isFavorite,
    String? backgroundColor,
  }) {
    return VideoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

/// Audiobook item type (Free, VIP Overlay)
enum AudiobookItemType {
  free,
  vipOverlay,
}

/// Model cho mỗi audiobook item
class AudiobookItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final AudiobookItemType type;
  final String duration; // "12:30"
  final bool isFavorite;
  final String? backgroundColor; // hex color

  const AudiobookItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.type,
    required this.duration,
    this.isFavorite = false,
    this.backgroundColor,
  });

  AudiobookItem copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    AudiobookItemType? type,
    String? duration,
    bool? isFavorite,
    String? backgroundColor,
  }) {
    return AudiobookItem(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

/// Demo data cho home screen
class HomeDataDemo {
  static HomeData get defaultData => HomeData(
        tabs: [
          const HomeTab(type: HomeTabType.story, isActive: true, itemCount: 24),
          const HomeTab(
              type: HomeTabType.video, isActive: false, itemCount: 15),
          const HomeTab(
              type: HomeTabType.audiobook, isActive: false, itemCount: 18),
          const HomeTab(
              type: HomeTabType.lesson, isActive: false, itemCount: 12),
        ],
        stories: _generateDemoStories(),
        videos: _generateDemoVideos(),
        audiobooks: _generateDemoAudiobooks(),
        activeTabIndex: 0,
        isVipUnlocked: false,
      );

  static List<StoryItem> _generateDemoStories() {
    return [
      const StoryItem(
        id: 'story_1',
        title: 'Alphabet Adventure A',
        thumbnailUrl: 'https://picsum.photos/seed/story1/300/400',
        type: StoryItemType.free,
        letter: 'A',
        backgroundColor: '#4F660C',
      ),
      const StoryItem(
        id: 'story_2',
        title: 'Alphabet Adventure B',
        thumbnailUrl: 'https://picsum.photos/seed/story2/300/400',
        type: StoryItemType.free,
        letter: 'B',
        backgroundColor: '#D2C08F',
      ),
      const StoryItem(
        id: 'story_3',
        title: 'Alphabet Adventure D',
        thumbnailUrl: 'https://picsum.photos/seed/story3/300/400',
        type: StoryItemType.free,
        letter: 'D',
        backgroundColor: '#F64960',
      ),
      const StoryItem(
        id: 'story_4',
        title: 'Alphabet Adventure VIP',
        thumbnailUrl: 'https://picsum.photos/seed/story4/300/400',
        type: StoryItemType.vip,
        letter: 'A',
        backgroundColor: '#A6A813',
      ),
      const StoryItem(
        id: 'story_5',
        title: 'Alphabet Adventure Premium',
        thumbnailUrl: 'https://picsum.photos/seed/story5/300/400',
        type: StoryItemType.vipOverlay,
        letter: 'A',
        backgroundColor: '#004743',
      ),
      const StoryItem(
        id: 'story_6',
        title: 'Alphabet Adventure Premium 2',
        thumbnailUrl: 'https://picsum.photos/seed/story6/300/400',
        type: StoryItemType.vipOverlay,
        letter: 'A',
        backgroundColor: '#67D1FF',
      ),
      const StoryItem(
        id: 'story_7',
        title: 'Alphabet Adventure Premium 3',
        thumbnailUrl: 'https://picsum.photos/seed/story7/300/400',
        type: StoryItemType.vipOverlay,
        letter: 'A',
        backgroundColor: '#1B425C',
      ),
      const StoryItem(
        id: 'story_8',
        title: 'Alphabet Adventure Premium 4',
        thumbnailUrl: 'https://picsum.photos/seed/story8/300/400',
        type: StoryItemType.vipOverlay,
        letter: 'A',
        backgroundColor: '#4F660C',
      ),
      const StoryItem(
        id: 'story_9',
        title: 'Alphabet Adventure Premium 5',
        thumbnailUrl: 'https://picsum.photos/seed/story9/300/400',
        type: StoryItemType.vipOverlay,
        letter: 'B',
        backgroundColor: '#D2C08F',
      ),
      const StoryItem(
        id: 'story_10',
        title: 'Alphabet Adventure Premium 6',
        thumbnailUrl: 'https://picsum.photos/seed/story10/300/400',
        type: StoryItemType.vipOverlay,
        letter: 'D',
        backgroundColor: '#F64960',
      ),
      const StoryItem(
        id: 'story_11',
        title: 'Alphabet Adventure Premium 7',
        thumbnailUrl: 'https://picsum.photos/seed/story11/300/400',
        type: StoryItemType.vipOverlay,
        letter: 'A',
        backgroundColor: '#111E3D',
      ),
      const StoryItem(
        id: 'story_12',
        title: 'Alphabet Adventure Premium 8',
        thumbnailUrl: 'https://picsum.photos/seed/story12/300/400',
        type: StoryItemType.vipOverlay,
        letter: 'A',
        backgroundColor: '#004743',
      ),
    ];
  }

  static List<VideoItem> _generateDemoVideos() {
    return [
      const VideoItem(
        id: 'video_1',
        title: 'Alphabet Adventure Video 1',
        thumbnailUrl: 'https://picsum.photos/seed/video1/300/400',
        type: VideoItemType.free,
        duration: '12:30',
        backgroundColor: '#4F660C',
      ),
      const VideoItem(
        id: 'video_2',
        title: 'Alphabet Adventure Video 2',
        thumbnailUrl: 'https://picsum.photos/seed/video2/300/400',
        type: VideoItemType.free,
        duration: '15:00',
        backgroundColor: '#D2C08F',
      ),
      const VideoItem(
        id: 'video_3',
        title: 'Alphabet Adventure Video 3',
        thumbnailUrl: 'https://picsum.photos/seed/video3/300/400',
        type: VideoItemType.free,
        duration: '10:15',
        backgroundColor: '#F64960',
      ),
      const VideoItem(
        id: 'video_4',
        title: 'Alphabet Adventure Video VIP',
        thumbnailUrl: 'https://picsum.photos/seed/video4/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#A6A813',
      ),
      const VideoItem(
        id: 'video_5',
        title: 'Alphabet Adventure Video Premium',
        thumbnailUrl: 'https://picsum.photos/seed/video5/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#004743',
      ),
      const VideoItem(
        id: 'video_6',
        title: 'Alphabet Adventure Video Premium 2',
        thumbnailUrl: 'https://picsum.photos/seed/video6/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#67D1FF',
      ),
      const VideoItem(
        id: 'video_7',
        title: 'Alphabet Adventure Video Premium 3',
        thumbnailUrl: 'https://picsum.photos/seed/video7/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#1B425C',
      ),
      const VideoItem(
        id: 'video_8',
        title: 'Alphabet Adventure Video Premium 4',
        thumbnailUrl: 'https://picsum.photos/seed/video8/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#4F660C',
      ),
      const VideoItem(
        id: 'video_9',
        title: 'Alphabet Adventure Video Premium 5',
        thumbnailUrl: 'https://picsum.photos/seed/video9/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#D2C08F',
      ),
      const VideoItem(
        id: 'video_10',
        title: 'Alphabet Adventure Video Premium 6',
        thumbnailUrl: 'https://picsum.photos/seed/video10/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#F64960',
      ),
      const VideoItem(
        id: 'video_11',
        title: 'Alphabet Adventure Video Premium 7',
        thumbnailUrl: 'https://picsum.photos/seed/video11/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#111E3D',
      ),
      const VideoItem(
        id: 'video_12',
        title: 'Alphabet Adventure Video Premium 8',
        thumbnailUrl: 'https://picsum.photos/seed/video12/300/400',
        type: VideoItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#004743',
      ),
    ];
  }

  static List<AudiobookItem> _generateDemoAudiobooks() {
    return [
      const AudiobookItem(
        id: 'audiobook_1',
        title: 'Alphabet Adventure Audiobook 1',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook1/300/400',
        type: AudiobookItemType.free,
        duration: '12:30',
        backgroundColor: '#4F660C',
      ),
      const AudiobookItem(
        id: 'audiobook_2',
        title: 'Alphabet Adventure Audiobook 2',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook2/300/400',
        type: AudiobookItemType.free,
        duration: '15:00',
        backgroundColor: '#D2C08F',
      ),
      const AudiobookItem(
        id: 'audiobook_3',
        title: 'Alphabet Adventure Audiobook 3',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook3/300/400',
        type: AudiobookItemType.free,
        duration: '10:15',
        backgroundColor: '#F64960',
      ),
      const AudiobookItem(
        id: 'audiobook_4',
        title: 'Alphabet Adventure Audiobook VIP',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook4/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#A6A813',
      ),
      const AudiobookItem(
        id: 'audiobook_5',
        title: 'Alphabet Adventure Audiobook Premium',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook5/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#004743',
      ),
      const AudiobookItem(
        id: 'audiobook_6',
        title: 'Alphabet Adventure Audiobook Premium 2',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook6/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#67D1FF',
      ),
      const AudiobookItem(
        id: 'audiobook_7',
        title: 'Alphabet Adventure Audiobook Premium 3',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook7/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#1B425C',
      ),
      const AudiobookItem(
        id: 'audiobook_8',
        title: 'Alphabet Adventure Audiobook Premium 4',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook8/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#4F660C',
      ),
      const AudiobookItem(
        id: 'audiobook_9',
        title: 'Alphabet Adventure Audiobook Premium 5',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook9/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#D2C08F',
      ),
      const AudiobookItem(
        id: 'audiobook_10',
        title: 'Alphabet Adventure Audiobook Premium 6',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook10/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#F64960',
      ),
      const AudiobookItem(
        id: 'audiobook_11',
        title: 'Alphabet Adventure Audiobook Premium 7',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook11/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#111E3D',
      ),
      const AudiobookItem(
        id: 'audiobook_12',
        title: 'Alphabet Adventure Audiobook Premium 8',
        thumbnailUrl: 'https://picsum.photos/seed/audiobook12/300/400',
        type: AudiobookItemType.vipOverlay,
        duration: '15:00',
        backgroundColor: '#004743',
      ),
    ];
  }
}
