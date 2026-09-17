# App-specific ProGuard rules (release). Flutter engine rules are added by the Flutter Gradle Plugin.

# Keep Flutter embedding and plugins (see flutter/flutter#154580).
-if class * implements io.flutter.embedding.engine.plugins.FlutterPlugin
-keep,allowshrinking,allowobfuscation class <1>
