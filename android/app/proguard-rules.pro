# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep your application class
-keep class com.example.food_dairy_app.** { *; }

# Keep all classes that might be used in reflection
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepattributes Signature

# Keep Gson stuff
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

# Keep SQLite
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.** { *; }

# Keep multidex
-keep class androidx.multidex.** { *; } 