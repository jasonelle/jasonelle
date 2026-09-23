plugins {
  id("com.android.application")
  id("org.jetbrains.kotlin.android")
  id("org.jetbrains.kotlin.plugin.compose")
  id("org.jlleitschuh.gradle.ktlint")
}

android {
  namespace = "com.jasonelle.application"
  compileSdk = 34

  defaultConfig {
    applicationId = "com.example.application"
    minSdk = 30
    targetSdk = 34
    versionCode = 1
    versionName = "4.0.0"

    testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
  }

  buildTypes {
    release {
      isMinifyEnabled = false
    }
  }

  buildFeatures {
    compose = true
  }

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
  }

  kotlinOptions {
    jvmTarget = "21"
  }
}

dependencies {
  implementation(project(":JLKernel"))
  implementation(project(":JLPluginHello"))
  implementation(project(":JLPluginDevice"))
  implementation(project(":JLPluginCookies"))

  implementation("androidx.core:core-ktx:1.13.1")
  implementation("androidx.activity:activity-compose:1.9.3")
  implementation(platform("androidx.compose:compose-bom:2024.10.01"))
  implementation("androidx.compose.ui:ui")
  implementation("androidx.compose.foundation:foundation")
  implementation("androidx.compose.material3:material3")
}
