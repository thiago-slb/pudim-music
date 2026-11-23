import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "io.github.thiagoslb.pudim"
    compileSdk = 37 // flutter_local_notifications 23 pede a API 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications usa APIs de data do Java 8+ (desugaring).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // Build próprio com outro id: variável de ambiente PUDIM_APP_ID ou -Ppudim.appId=... (ver README).
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

    // No Android o áudio é o ExoPlayer (just_audio); o mpv do media_kit só serve no desktop.
    // Os dois System.loadLibrary do plugin estão em try/catch, então tirar as .so é seguro (~7 MB por arquitetura).
    packaging {
        jniLibs {
            excludes += setOf("**/libmpv.so", "**/libmediakitandroidhelper.so")
        }
    }

    // Chave de release: android/key.properties (fora do git, ver README). Sem ele, assina com a de debug.
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
