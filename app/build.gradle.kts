plugins {
    id("com.android.application")
}

android {
	namespace = "dev.materii.rushii.xspoofsignatures"
	compileSdk = 35

	defaultConfig {
		applicationId = "dev.materii.rushii.xspoofsignatures"
		minSdk = 29
		versionCode = 4
		versionName = "2.1.0"
	}

	buildTypes {
		release {
			isMinifyEnabled = true
			isShrinkResources = true
			proguardFiles(
				getDefaultProguardFile("proguard-android-optimize.txt"),
				"proguard-rules.pro",
			)

			if (System.getenv("RELEASE") == "true") {
				signingConfig = signingConfigs.getByName("release")
			} else {
				signingConfig = signingConfigs.getByName("debug")
			}
		}
	}

	compileOptions {
		sourceCompatibility = JavaVersion.VERSION_17
		targetCompatibility = JavaVersion.VERSION_17
	}
}

tasks.withType<JavaCompile> {
	options.compilerArgs.add("-Xlint:-deprecation")
}

dependencies {
	compileOnly("de.robv.android.xposed:api:82")
}
