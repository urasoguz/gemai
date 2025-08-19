import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';

/// Basit HTML içerik gösterici - Sadece text olarak
class SimpleHtmlView extends StatelessWidget {
  final String htmlContent;
  final String title;
  final bool showAppBar;

  const SimpleHtmlView({
    super.key,
    required this.htmlContent,
    required this.title,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    if (kDebugMode) {
      print('📄 SimpleHtmlView build:');
      print('   - Title: $title');
      print('   - HTML Length: ${htmlContent.length}');
      print(
        '   - HTML Preview: ${htmlContent.substring(0, htmlContent.length > 200 ? 200 : htmlContent.length)}...',
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar:
          showAppBar
              ? AppBar(
                backgroundColor: colors.background,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
              : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Html(
          data: htmlContent,
          style: {
            "body": Style(
              fontSize: FontSize(16),
              color: colors.textSecondary,
              lineHeight: LineHeight(1.6),
            ),
            "h1": Style(
              fontSize: FontSize(24),
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              margin: Margins.only(top: 24, bottom: 12),
            ),
            "h2": Style(
              fontSize: FontSize(20),
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              margin: Margins.only(top: 20, bottom: 10),
            ),
            "h3": Style(
              fontSize: FontSize(18),
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              margin: Margins.only(top: 16, bottom: 8),
            ),
            "p": Style(
              fontSize: FontSize(16),
              color: colors.textSecondary,
              margin: Margins.only(bottom: 12),
            ),
            "ul": Style(margin: Margins.only(bottom: 16)),
            "li": Style(
              fontSize: FontSize(16),
              color: colors.textSecondary,
              margin: Margins.only(bottom: 8),
            ),
            "strong": Style(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
            "b": Style(fontWeight: FontWeight.bold, color: colors.textPrimary),
            "em": Style(fontStyle: FontStyle.italic),
            "i": Style(fontStyle: FontStyle.italic),
            "u": Style(textDecoration: TextDecoration.underline),
            "a": Style(
              color: colors.primary,
              textDecoration: TextDecoration.underline,
            ),
          },
        ),
      ),
    );
  }
}
