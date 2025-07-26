# Razorpay SDK
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# AndroidX
-keep class androidx.** { *; }
-dontwarn androidx.**

# Kotlin
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# Flutter
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Keep all annotations
-keepattributes *Annotation*

# Keep reflection-based serialization
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
