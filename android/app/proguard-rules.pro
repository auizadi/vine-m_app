# android/app/proguard-rules.pro
-keep class org.tensorflow.** { *; }
-keep class com.ultralytics.** { *; }
-dontwarn org.tensorflow.**
-dontwarn java.beans.**
-keep class org.yaml.snakeyaml.** { *; }
-keep class java.beans.** { *; }
