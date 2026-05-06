/// Configuration for the WebView-backed pages hosted by the
/// Google Apps Script (GAS) deployment.
///
/// Replace [gasBaseUrl] with the deployed GAS web-app URL, e.g.:
///   https://script.google.com/macros/s/AKfycbz.../exec
///
/// Each [WebPage] maps a bottom-nav tab to a `nextPage` query parameter
/// understood by the GAS router.
class WebPage {
  final String key;
  final String title;
  const WebPage({required this.key, required this.title});

  /// Builds the full URL for this page using [gasBaseUrl].
  String url() => '$gasBaseUrl?nextPage=$key';
}

/// Deployed Google Apps Script web-app URL.
const String gasBaseUrl =
    'https://script.google.com/macros/s/AKfycbxCZk9SY7H8aDaVTXq3lmtL1k39QQZk2AiH2Y9YBAEEOJ7e7TvNGjYlRQclKfC0hTd3/exec';

/// Tabs shown in the bottom navigation bar, in display order
/// (left → right). The center tab (index 2) is rendered as a
/// raised FAB-style button.
const List<WebPage> webTabs = <WebPage>[
  WebPage(key: 'employee_schedule', title: '請假排班'),
  WebPage(key: 'employee_clock', title: '打卡紀錄'),
  WebPage(key: 'employee_home', title: '員工主頁'),
  WebPage(key: 'employee_salary', title: '薪資明細'),
  WebPage(key: 'employee_upload', title: '資料上傳'),
];

/// Internal page shown by the GAS router when the user lacks permission.
/// Not exposed as a tab; opened automatically when the WebView is
/// redirected to it.
const WebPage noPermPage = WebPage(key: 'noperm', title: '沒有權限');

/// Index of the center "員工主頁" tab — used as the initial tab and
/// rendered as a raised gradient FAB.
const int centerTabIndex = 2;
