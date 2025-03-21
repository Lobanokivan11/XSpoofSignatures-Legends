plugins {
    id("com.android.application")
}

android {
	namespace = "dev.materii.rushii.xspoofsignatures"
	compileSdk = 35

	defaultConfig {
		applicationId = "dev.materii.rushii.xspoofsignatures"
		minSdk = 3
		versionCode = 5
		versionName = "2.5.0"
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
}

dependencies {
	compileOnly("de.robv.android.xposed:api:82")
}
