buildscript {
	repositories {
		google()
		mavenCentral()
	}
	dependencies {
		classpath("com.android.tools.build:gradle:8.1.0")
	}
}

allprojects {
	repositories {
		google()
		mavenCentral()
		maven(url = "https://jcenter.bintray.com/")
        maven(url = "https://raw.githubusercontent.com/rovo89/XposedBridge/refs/heads/gh-pages/de/robv/android/xposed/api/")
	}
}

tasks.register<Delete>("clean") {
	delete(rootProject.buildDir)
}
