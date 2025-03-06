import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart' as page_flip;

/// A widget that provides a book-like page flip animation for the story reader
class PageFlipWidget extends StatefulWidget {
  final PageController controller;
  final int pageCount;
  final Function(int) onPageChanged;
  final Widget Function(BuildContext, int) itemBuilder;
  final VoidCallback? onNextPage;
  final VoidCallback? previousPage;

  const PageFlipWidget({
    Key? key,
    required this.controller,
    required this.pageCount,
    required this.onPageChanged,
    required this.itemBuilder,
    this.onNextPage,
    this.previousPage,
  }) : super(key: key);

  @override
  YouPageFlipWidgetState createState() => YouPageFlipWidgetState();
}

class YouPageFlipWidgetState extends State<PageFlipWidget> {
  // late PageFlipController _pageFlipController;
  final GlobalKey<page_flip.PageFlipWidgetState> _pageFlipController =
      GlobalKey<page_flip.PageFlipWidgetState>();

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.controller.initialPage;
    // _pageFlipController = PageFlipController();
    // _pageFlipController = GlobalKey<page_flip.PageFlipWidgetState>();
    // Sync the PageController with our PageFlipController
    widget.controller.addListener(_syncPageController);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncPageController);
    // _pageFlipController.dispose();
    super.dispose();
  }

  void nextPage() {
    print("nextPage");
    // _pageFlipController.currentState?.goToPage(5);
    _pageFlipController.currentState?.nextPage();
  }

  void previousPage() {
    print("previousPage");
    _pageFlipController.currentState?.previousPage();
  }

  void _syncPageController() {
    //  _pageFlipController.currentState?.previousPage();
    // print(widget.controller.page?.round());
    // final page = widget.controller.page?.round() ?? 0;
    // if (page != _currentPage) {
    //   // Only flip if the controller was moved by user interaction or programmatically
    //   // if (page > _currentPage) {
    //   //   _pageFlipController.flipToPage(
    //   //     from: _currentPage,
    //   //     to: page,
    //   //     duration: const Duration(milliseconds: 300),
    //   //     direction: AxisDirection.right,
    //   //   );
    //   // } else if (page < _currentPage) {
    //   //   _pageFlipController.flipToPage(
    //   //     from: _currentPage,
    //   //     to: page,
    //   //     duration: const Duration(milliseconds: 300),
    //   //     direction: AxisDirection.left,
    //   //   );
    //   // }

    //   setState(() {
    //     _currentPage = page;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return page_flip.PageFlipWidget(
      key: _pageFlipController,
      // onFlip: (int fromPage, int toPage) {
      //   // Update the PageController to match the PageFlip
      //   if (widget.controller.page?.round() != toPage) {
      //     widget.controller.jumpToPage(toPage);
      //   }

      //   // Call the onPageChanged callback
      //   if (_currentPage != toPage) {
      //     setState(() {
      //       _currentPage = toPage;
      //     });
      //     widget.onPageChanged(toPage);
      //   }
      // },
      // Customize the page flip effect
      // showDragCutoff: false,
      // cornerDragEnabled: true,
      // lastPage: widget.pageCount - 1,
      // flipOnTap: false,
      // flipDuration: const Duration(milliseconds: 300),
      // Customize the appearance
      backgroundColor: Colors.black,
      initialIndex: 0,
      children: List.generate(
        widget.pageCount,
        (index) => widget.itemBuilder(context, index),
      ),
      // shadowColor: Colors.black54,
      // shadowOpacity: 0.3,
    );
  }
}
