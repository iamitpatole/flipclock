# Flutter engine and plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# In-App Review and Google Play Core
-keep class com.google.android.play.core.** { *; }

# Preserve annotations and line numbers for crash reporting & stack traces
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Ignore harmless warnings
-dontwarn io.flutter.**
-dontwarn com.google.android.gms.**
-dontwarn com.google.android.play.core.**

