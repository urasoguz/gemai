import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/shared/widgets/modular_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final Function(String invoiceId)? onSuccess;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
    this.onSuccess,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  String url = "";
  String? invoiceId;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  this.url = url;
                });
              },
              onPageFinished: (String url) async {
                String htmlContent =
                    await _controller.runJavaScriptReturningResult(
                          'document.documentElement.outerHTML',
                        )
                        as String;
                extractInvoiceId(htmlContent);
              },
              onNavigationRequest: (NavigationRequest request) async {
                Uri uri = Uri.parse(request.url);
                if (!["http", "https"].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    return NavigationDecision.prevent;
                  }
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  void extractInvoiceId(String htmlContent) {
    RegExp regex = RegExp(
      r'<p class="text-\[#6D7F9A\] text-sm select-all">([^<]+)</p>',
    );
    Match? match = regex.firstMatch(htmlContent);
    if (match != null) {
      setState(() {
        invoiceId = match.group(1);
      });
      if (widget.onSuccess != null) {
        widget.onSuccess!(invoiceId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        title: widget.title,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppThemeConfig.textPrimary),
          onPressed: () async {
            if (await _controller.canGoBack()) {
              _controller.goBack();
            } else {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            }
          },
        ),
        backgroundColor: AppThemeConfig.background,
        elevation: 0,
        // actions parametresi yanlış, ModularAppBar'da doğru parametreyi kullanmalısınız
        trailing: IconButton(
          icon: Icon(Icons.close, color: AppThemeConfig.textPrimary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
