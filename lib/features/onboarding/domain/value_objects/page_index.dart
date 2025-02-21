class PageIndex {
  final int value;

  PageIndex._(this.value);

  static PageIndex create(int index) {
    if (index < 0) {
      throw ArgumentError('Page index cannot be negative');
    }
    return PageIndex._(index);
  }

  bool isLastPage(int totalPages) {
    return value == totalPages - 1;
  }

  bool isFirstPage() {
    return value == 0;
  }
}
