## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

## UCrop (image_cropper)
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn com.google.android.play.core.**

## General
-ignorewarnings
-dontwarn **
-keepattributes Signature
-keepattributes *Annotation*
