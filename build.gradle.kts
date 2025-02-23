buildscript {
	repositories {
		google()
		mavenCentral()
	}
	dependencies {
		classpath("com.android.tools.build:gradle:8.10.0-alpha05")
	}
}

allprojects {
	repositories {
		google()
		mavenCentral()
		maven(url = "https://jcenter.bintray.com/")
        maven(url = "https://api.xposed.info/")
	}
}

tasks.register<Delete>("clean") {
	delete(rootProject.buildDir)
}
