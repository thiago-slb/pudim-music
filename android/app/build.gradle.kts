import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "io.github.thiagoslb.pudim"
    compileSdk = 37 // flutter_local_notifications 23 requires API 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications uses Java 8+ date APIs (desugaring).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // Custom build with another id: environment variable PUDIM_APP_ID or -Ppudim.appId=... (see README).
        applicationId = providers.gradleProperty("pudim.appId")
            .orElse(providers.environmentVariable("PUDIM_APP_ID"))
            .getOrElse("io.github.thiagoslb.pudim")
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // On Android the audio engine is ExoPlayer (just_audio); media_kit's mpv is only needed on desktop.
    // The plugin's two System.loadLibrary calls are in try/catch, so dropping the .so files is safe (~7 MB per architecture).
    packaging {
        jniLibs {
            excludes += setOf("**/libmpv.so", "**/libmediakitandroidhelper.so")
        }
    }

    // Release key: android/key.properties (not in git, see README). Without it, signs with the debug key.
    val keyProps = Properties().apply {
        val f = rootProject.file("key.properties")
        if (f.exists()) f.inputStream().use { load(it) }
    }
    signingConfigs {
        if (keyProps.getProperty("storeFile") != null) {
            create("release") {
                storeFile = file(keyProps.getProperty("storeFile"))
                storePassword = keyProps.getProperty("storePassword")
                keyAlias = keyProps.getProperty("keyAlias")
                keyPassword = keyProps.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release") ?: signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
