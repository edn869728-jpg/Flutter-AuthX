import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A self-contained, stateful WebView for a single bottom-nav tab.
///
/// Each instance owns its own [WebViewController], so swapping tabs
/// inside an `IndexedStack` preserves scroll position, form input,
/// and history per-tab — no reload on tab switch.
class WebViewTab extends StatefulWidget {
  final String url;
  const WebViewTab({super.key, required this.url});

  @override
  State<WebViewTab> createState() => _WebViewTabState();
}

class _WebViewTabState extends State<WebViewTab>
    with AutomaticKeepAliveClientMixin<WebViewTab> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
