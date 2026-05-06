import 'package:flutter/material.dart';
import 'package:to_do_app/res/web_pages.dart';
import 'package:to_do_app/view/webview/web_view_tab.dart';

/// Top-level scaffold shown after the user signs in.
///
/// Hosts five independent WebViews (one per [webTabs] entry) inside an
/// [IndexedStack] so each tab keeps its own state, and renders a custom
/// bottom navigation bar with a raised, gradient FAB-style button for
/// the centre "員工主頁" tab — matching the design mockup.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = centerTabIndex;

  static const List<IconData> _icons = <IconData>[
    Icons.event_note_outlined,
    Icons.history_toggle_off,
    Icons.home_rounded, // centre — drawn separately as the FAB
    Icons.receipt_long_outlined,
    Icons.upload_file_outlined,
  ];

  static const Gradient _centerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFFFFB6E1), // pink
      Color(0xFFB89BFF), // purple
      Color(0xFF9CC8FF), // blue
    ],
  );

  void _onTap(int i) {
    if (i == _index) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: <Widget>[
            for (final WebPage page in webTabs)
              WebViewTab(key: ValueKey<String>(page.key), url: page.url()),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        icons: _icons,
        labels: webTabs.map((WebPage p) => p.title).toList(),
        currentIndex: _index,
        centerIndex: centerTabIndex,
        centerGradient: _centerGradient,
        onTap: _onTap,
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final List<IconData> icons;
  final List<String> labels;
  final int currentIndex;
  final int centerIndex;
  final Gradient centerGradient;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.icons,
    required this.labels,
    required this.currentIndex,
    required this.centerIndex,
    required this.centerGradient,
    required this.onTap,
  });

  static const double _barHeight = 72;
  static const double _fabSize = 64;
  static const double _fabLift = 22; // how far above the bar the FAB sits
  static const double _fabVerticalOffset = 6; // fine-tune so FAB sits flush above the bar

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return SizedBox(
      height: _barHeight + _fabLift + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Rounded white bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: _barHeight + bottomInset,
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  for (int i = 0; i < icons.length; i++)
                    Expanded(
                      child: i == centerIndex
                          // Reserve the centre slot — the FAB is drawn above.
                          ? const SizedBox.shrink()
                          : _NavItem(
                              icon: icons[i],
                              label: labels[i],
                              selected: currentIndex == i,
                              onTap: () => onTap(i),
                            ),
                    ),
                ],
              ),
            ),
          ),
          // Centre FAB-style button + its label
          Positioned(
            bottom: _barHeight + bottomInset - (_fabSize / 2) - _fabLift + _fabVerticalOffset,
            child: _CenterFab(
              icon: icons[centerIndex],
              label: labels[centerIndex],
              size: _fabSize,
              gradient: centerGradient,
              selected: currentIndex == centerIndex,
              onTap: () => onTap(centerIndex),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        selected ? const Color(0xFF7B61FF) : const Color(0xFF9AA0B4);
    return InkResponse(
      onTap: onTap,
      radius: 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterFab extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;
  final Gradient gradient;
  final bool selected;
  final VoidCallback onTap;

  const _CenterFab({
    required this.icon,
    required this.label,
    required this.size,
    required this.gradient,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x33B89BFF),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: selected
                ? const Color(0xFF7B61FF)
                : const Color(0xFF4A4A6A),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
