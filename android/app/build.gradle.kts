import java.util.Base64
import java.util.Properties

// Push (Firebase Cloud Messaging): the Firebase ids come from the build's --dart-define values
// (PUDIM_FCM_*, kept out of git with the other addresses). They become the string resources Firebase
// reads at startup, so a push also arrives with the app closed. Without them, the app has no push.
val dartDefines: Map<String, String> = (project.findProperty("dart-defines") as String?)
    ?.split(",")
    ?.mapNotNull { runCatching { String(Base64.getDecoder().decode(it), Charsets.UTF_8) }.getOrNull() }
    ?.mapNotNull { it.split("=", limit = 2).takeIf { kv -> kv.size == 2 }?.let { kv -> kv[0] to kv[1] } }
    ?.toMap() ?: emptyMap()

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

        val fcm = listOf("PUDIM_FCM_APP_ID", "PUDIM_FCM_API_KEY", "PUDIM_FCM_PROJECT_ID", "PUDIM_FCM_SENDER_ID")
            .map { dartDefines[it].orEmpty() }
        if (fcm.all { it.isNotEmpty() }) {
            resValue("string", "google_app_id", fcm[0])
            resValue("string", "google_api_key", fcm[1])
            resValue("string", "project_id", fcm[2])
            resValue("string", "gcm_defaultSenderId", fcm[3])
        }
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
    // Push for chat and Jam invites (native: the Flutter plugin would add Firebase's C++ SDK to the Windows build).
    implementation("com.google.firebase:firebase-messaging:24.1.2")
}
