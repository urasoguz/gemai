import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/shared/widgets/modular_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

/// HTML içeriği göstermek için WebView widget'ı
class HtmlViewScreen extends StatefulWidget {
  final String htmlContent;
  final String title;
  final bool showAppBar;

  const HtmlViewScreen({
    super.key,
    required this.htmlContent,
    required this.title,
    this.showAppBar = true,
  });

  @override
  State<HtmlViewScreen> createState() => _HtmlViewScreenState();
}

class _HtmlViewScreenState extends State<HtmlViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print('📄 HtmlViewScreen initState:');
      print('   - Title: ${widget.title}');
      print('   - HTML Length: ${widget.htmlContent.length}');
      print(
        '   - HTML Preview: ${widget.htmlContent.substring(0, widget.htmlContent.length > 200 ? 200 : widget.htmlContent.length)}...',
      );
    }

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                if (kDebugMode) {
                  print('📄 WebView page started: $url');
                }
              },
              onPageFinished: (String url) async {
                if (kDebugMode) {
                  print('📄 WebView page finished: $url');
                }

                // HTML content'i kontrol et
                try {
                  final htmlContent =
                      await _controller.runJavaScriptReturningResult(
                            'document.documentElement.outerHTML',
                          )
                          as String;
                  final bodyContent =
                      await _controller.runJavaScriptReturningResult(
                            'document.body.innerHTML',
                          )
                          as String;
                  if (kDebugMode) {
                    print(
                      '📄 WebView HTML Content Length: ${htmlContent.length}',
                    );
                    print(
                      '📄 WebView Body Content Length: ${bodyContent.length}',
                    );
                    print(
                      '📄 WebView Body Preview: ${bodyContent.substring(0, bodyContent.length > 200 ? 200 : bodyContent.length)}...',
                    );
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print('❌ WebView HTML content alınamadı: $e');
                  }
                }
              },
              onNavigationRequest: (NavigationRequest request) {
                if (kDebugMode) {
                  print('📄 Navigation request: ${request.url}');
                }
                // Harici linkleri engelle
                return NavigationDecision.prevent;
              },
              onWebResourceError: (WebResourceError error) {
                if (kDebugMode) {
                  print('❌ WebView Error: ${error.description}');
                }
              },
            ),
          );

    // HTML content'i yükle
    final htmlContent = _buildHtmlContent();
    if (kDebugMode) {
      print('📄 Generated HTML Content Length: ${htmlContent.length}');
      print(
        '📄 Generated HTML Preview: ${htmlContent.substring(0, htmlContent.length > 500 ? 500 : htmlContent.length)}...',
      );
    }

    // WebView'i yükle - Alternatif yaklaşım
    try {
      // Önce data URL ile dene
      final dataUrl = Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      );

      if (kDebugMode) {
        print(
          '📄 Data URL oluşturuldu: ${dataUrl.toString().substring(0, 100)}...',
        );
      }

      _controller.loadRequest(dataUrl);
      if (kDebugMode) {
        print('📄 WebView loadRequest çağrıldı');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ WebView loadRequest hatası: $e');
        print('📄 loadHtmlString ile dene...');
      }

      try {
        _controller.loadHtmlString(htmlContent);
        if (kDebugMode) {
          print('📄 WebView loadHtmlString çağrıldı');
        }
      } catch (e2) {
        if (kDebugMode) {
          print('❌ WebView loadHtmlString hatası: $e2');
        }
      }
    }
  }

  /// HTML içeriğini tema ile uyumlu hale getirir
  String _buildHtmlContent() {
    final colors = _getColors();

    if (kDebugMode) {
      print('📄 HTML Content Length: ${widget.htmlContent.length}');
      print(
        '📄 HTML Content Preview: ${widget.htmlContent.substring(0, widget.htmlContent.length > 100 ? 100 : widget.htmlContent.length)}...',
      );
    }

    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta charset="UTF-8">
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 16px;
            background-color: ${_colorToHex(colors.background)};
            color: ${_colorToHex(colors.textPrimary)};
            line-height: 1.6;
            font-size: 16px;
          }
          h1, h2, h3, h4, h5, h6 {
            color: ${_colorToHex(colors.textPrimary)};
            margin-top: 24px;
            margin-bottom: 12px;
          }
          h1 { font-size: 24px; font-weight: bold; }
          h2 { font-size: 20px; font-weight: bold; }
          h3 { font-size: 18px; font-weight: bold; }
          p {
            margin-bottom: 16px;
            color: ${_colorToHex(colors.textSecondary)};
          }
          ul, ol {
            margin-bottom: 16px;
            padding-left: 20px;
          }
          li {
            margin-bottom: 8px;
            color: ${_colorToHex(colors.textSecondary)};
          }
          a {
            color: ${_colorToHex(colors.primary)};
            text-decoration: underline;
          }
          strong, b {
            font-weight: bold;
            color: ${_colorToHex(colors.textPrimary)};
          }
          em, i {
            font-style: italic;
          }
          blockquote {
            border-left: 4px solid ${_colorToHex(colors.primary)};
            margin: 16px 0;
            padding-left: 16px;
            color: ${_colorToHex(colors.textSecondary)};
          }
          code {
            background-color: ${_colorToHex(colors.card)};
            padding: 2px 6px;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
          }
          pre {
            background-color: ${_colorToHex(colors.card)};
            padding: 16px;
            border-radius: 8px;
            overflow-x: auto;
            margin: 16px 0;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            margin: 16px 0;
          }
          th, td {
            border: 1px solid ${_colorToHex(colors.divider)};
            padding: 8px 12px;
            text-align: left;
          }
          th {
            background-color: ${_colorToHex(colors.card)};
            font-weight: bold;
          }
        </style>
      </head>
      <body>
        ${widget.htmlContent}
      </body>
      </html>
    ''';
  }

  /// Tema renklerini alır
  dynamic _getColors() {
    // Build context olmadan çağrıldığı için varsayılan renkleri kullanıyoruz
    return AppThemeConfig.lightColors;
  }

  /// Color'ı hex string'e çevirir
  String _colorToHex(dynamic color) {
    if (color is Color) {
      // ignore: deprecated_member_use
      return '#${color.value.toRadixString(16).padLeft(8, '0')}';
    }
    // Eğer color bir string ise direkt döndür
    return color.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar:
          widget.showAppBar
              ? ModularAppBar(
                title: widget.title,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(CupertinoIcons.back, color: colors.textPrimary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
              : null,
      body: WebViewWidget(controller: _controller),
    );
  }
}
