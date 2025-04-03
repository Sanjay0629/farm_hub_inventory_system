# Razorpay SDK
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# GPay-related classes required by Razorpay
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**

# Annotations required by Razorpay
-keep class proguard.annotation.** { *; }
-dontwarn proguard.annotation.**

# Prevent R8 from stripping Flutter plugins
-keep class io.flutter.plugins.** { *; }

# Required for serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Firebase and Google services
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
