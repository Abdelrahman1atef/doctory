package com.doctory

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    // Deep links are fully handled by app_links + DeepLinkService (Dart side).
    // Flutter's built-in forwarding pushes the raw intent URI straight into
    // GoRouter as a route name, racing our own handler's navigation.
    override fun shouldHandleDeeplinking(): Boolean = false
}
