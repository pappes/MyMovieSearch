plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.my_movie_search"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358" //flutter.ndkVersion //was defaulting to "NDK 26.3.11579264"  for flutter 3.22.8

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.my_movie_search"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 28 //flutter.minSdkVersion // S8 has andriod version 9 = API 28
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }


    // 1. Defining the flavor dimension
    flavorDimensions += listOf("app")

    // 2. Defining product flavors
    productFlavors {
        create("dev") {
            dimension = "app"
            // FIX: Set a distinct app title for the development build.
            resValue("string", "app_name", "Aperture (Dev)")
        }

        create("prod") {
            dimension = "app"
            applicationIdSuffix = ".prod"
            // FIX: Set the production app title.
            resValue("string", "app_name", "Aperture") 
            // alternative names Aurora , Crescendo, Fable, Glimpse, Glow, Glyph*, Mythos, Odyssey, Paradox, Relic, Saga, Zenith**
        }
    }
}


// =====================================================================
// DEFAULT FLAVOR FIX & APK RENAMING (The final, robust solution)
// =====================================================================
// The afterEvaluate block runs *after* the project configuration is complete,
// allowing us to modify task dependencies and add post-build steps.
afterEvaluate {
    val assembleReleaseTask = project.tasks.findByName("assembleRelease")
    val assembleProdReleaseTask = project.tasks.findByName("assembleProdRelease")
    val assembleDevReleaseTask = project.tasks.findByName("assembleDevRelease") // The task that creates our target APK

    // Check if the user explicitly requested any task containing 'prod'
    val requestedTasks = project.gradle.startParameter.taskNames
    val isProdRequested = requestedTasks.any { it.contains("prod", ignoreCase = true) }
    
    // --- 1. Task Dependency Fix ---
    // Problem: By default, 'assembleRelease' depends on ALL release flavor tasks ('assembleDevRelease', 'assembleProdRelease').
    // Solution: If the user didn't request '--flavor=prod', we disable the prod task and remove it as a dependency,
    // ensuring only the 'dev' build runs when 'flutter build apk' is executed.
    if (assembleProdReleaseTask != null && assembleReleaseTask != null && !isProdRequested) {
        assembleProdReleaseTask.enabled = false
        println("INFO: Disabling assembleProdRelease task by default. Use --flavor=prod to build.")

        val newDependencies = assembleReleaseTask.taskDependencies.getDependencies(assembleReleaseTask)
            .filter { it.name != assembleProdReleaseTask.name }
            .toSet()
        
        assembleReleaseTask.setDependsOn(newDependencies)
    }

    // --- 2. APK Renaming Fix ---
    // Problem: 'assembleDevRelease' creates 'app-dev-release.apk' in the flavored output directory.
    // The Flutter CLI looks *only* for 'app-release.apk' in the 'flutter-apk' directory.
    // Solution: We add a 'doLast' action to the 'dev' task to copy and rename the file to the location Flutter expects.
    if (assembleDevReleaseTask != null) {
        // This doLast block executes *after* assembleDevRelease successfully creates the APK.
        assembleDevReleaseTask.doLast {
            // 1. The actual directory where Gradle places the flavored APK:
            val gradleApkDir = file("${project.buildDir}/outputs/apk/dev/release")
            val originalApk = file("${gradleApkDir}/app-dev-release.apk")
            
            // 2. The directory where the Flutter CLI looks for the final APK:
            // We use project.rootProject.buildDir to ensure the path starts correctly from the top-level 'build'.
            val flutterOutputDir = file("${project.rootProject.buildDir}/app/outputs/flutter-apk")
            val targetApk = file("${flutterOutputDir}/app-release.apk")

            // Ensure the Flutter target directory exists.
            flutterOutputDir.mkdirs()

            if (originalApk.exists()) {
                // Rename/move the file to the expected name.
                originalApk.copyTo(targetApk, overwrite = true)
                println("INFO: Successfully copied and renamed APK from ${originalApk.absolutePath} to ${targetApk.absolutePath} for Flutter compatibility.")
            } else {
                println("WARN: Renaming failed. Could not find expected APK at: ${originalApk.absolutePath}. Did the build fail?")
            }
        }
        println("INFO: Added post-build action to rename APK for Flutter compatibility.")
    }
    
    if (assembleReleaseTask != null) {
        // DEBUG: Confirm which tasks 'assembleRelease' actually depends on now.
        val dependencies = assembleReleaseTask.taskDependencies.getDependencies(assembleReleaseTask)
        println("DEBUG: assembleRelease dependencies (after dependency modification): ${dependencies.joinToString { it.name }}")
    }
}


flutter {
    source = "../.."
}
