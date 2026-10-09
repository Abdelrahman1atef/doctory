import 'package:doctory/core/utils/parse_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../services/alerts.dart';

class AbherPaymentWebView extends StatefulWidget {
  final String url;
  final void Function(bool success)? onPaymentResult;

  const AbherPaymentWebView({
    super.key,
    required this.url,
    this.onPaymentResult,
  });

  @override
  State<AbherPaymentWebView> createState() => _AbherPaymentWebViewState();
}

class _AbherPaymentWebViewState extends State<AbherPaymentWebView> {
  /// Scheme of the app's own return URL
  /// (`doctory://payment-result?success=…&order=…`).
  static const String _appScheme = 'doctory';
  static const Duration _resultDelay = Duration(seconds: 2);

  late final WebViewController _controller;

  /// The result can be detected both from a gateway page URL and from the
  /// final redirect to the app; only the first one is acted on.
  bool _resultHandled = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
          Page resource error:
        code: ${error.errorCode}
        description: ${error.description}
        errorType: ${error.errorType}
        isForMainFrame: ${error.isForMainFrame}
              ''');
          },
          onNavigationRequest: _onNavigationRequest,
          onUrlChange: (UrlChange change) => _onUrlChange(change.url ?? ''),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    // The gateway finishes by redirecting to the app's return URL, which the
    // webview cannot load ("Web page not available"). Read the result from
    // it and close the webview instead.
    if (uri != null && uri.scheme == _appScheme) {
      _completePayment(ParseUtils.ensureBool(uri.queryParameters['success']));
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  void _onUrlChange(String url) {
    if (url.contains('message=APPROVED') ||
        url.contains('status=success') ||
        url.contains('SUCCESS') ||
        url.contains('success=True')) {
      _completePayment(true);
    } else if (url.contains("status=failed") ||
        url.contains("status=error") ||
        url.contains("FAILED") ||
        url.contains("success=False")) {
      _completePayment(false);
    }
  }

  Future<void> _completePayment(bool success) async {
    if (_resultHandled || !mounted) return;
    _resultHandled = true;

    Alerts.snack(
      text: (success ? 'payment_success' : 'payment_failed').tr(),
      state: success ? SnackState.success : SnackState.failed,
    );

    await Future<void>.delayed(_resultDelay);
    if (!mounted) return;

    if (success && widget.onPaymentResult == null) {
      context.go(AppRoutes.login);
      return;
    }
    widget.onPaymentResult?.call(success);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'pay'.tr(),
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 16.0,
          ),
        ),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
