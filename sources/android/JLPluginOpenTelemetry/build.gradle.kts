plugins {
  id("com.android.library")
  id("org.jetbrains.kotlin.android")
  id("org.jlleitschuh.gradle.ktlint")
}

android {
  namespace = "com.jasonelle.plugins.opentelemetry"
  compileSdk = 34

  defaultConfig {
    minSdk = 30
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

  implementation("io.opentelemetry:opentelemetry-api:1.30.0")
  implementation("io.opentelemetry:opentelemetry-sdk:1.30.0")

  testImplementation("junit:junit:4.13.2")
  testImplementation("org.json:json:20240303")
}
