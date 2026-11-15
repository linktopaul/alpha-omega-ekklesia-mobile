plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "org.aoekklesia.alpha_omega_ekklesia_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "org.aoekklesia.alpha_omega_ekklesia_mobile"
        minSdk = maxOf(flutter.minSdkVersion, 24)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        val redirectScheme = (project.findProperty("appAuthRedirectScheme") as String?)
            ?.trim()
            ?.takeIf { it.isNotEmpty() }
            ?: System.getenv("CHURCH_AUTH_REDIRECT_SCHEME")?.trim()?.takeIf { it.isNotEmpty() }
            ?: "org.aoekklesia"
        manifestPlaceholders["appAuthRedirectScheme"] = redirectScheme
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
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
