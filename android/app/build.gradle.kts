plugins {
    id("com.android.application")
    id("kotlin-android")
    
    // Le plugin Flutter doit être après Android et Kotlin
    id("dev.flutter.flutter-gradle-plugin")

    // 🔥 Ajout du plugin Google Services pour Firebase
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.keepaar_messagerie"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.keepaar_messagerie"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 🔥 Activation du support MultiDex pour Firebase Cloud Messaging
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            minifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

dependencies {
    // 📌 Gestion automatique des versions compatibles Firebase
    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))

    // 🔥 Ajout des dépendances Firebase essentielles
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-auth")
}

flutter {
    source = "../.."
}