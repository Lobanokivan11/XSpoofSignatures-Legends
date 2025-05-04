plugins {
    id("com.android.application")
}

android {
	namespace = "dev.materii.rushii.xspoofsignatures"
	compileSdk = 35

        signingConfigs {
    	    create("release") {
        	    storeFile = file("../sign.keystore")
        	    storePassword = "369852"
        	    keyAlias = "lob"
        	    keyPassword = "369852"
    	    }
        }

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
			signingConfig = signingConfigs.getByName("release")
		}
	}
}

dependencies {
	compileOnly("de.robv.android.xposed:api:82")
}
