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
    // --- Task Definitions ---
    // Release tasks
    val assembleReleaseTask = project.tasks.findByName("assembleRelease")
    val assembleProdReleaseTask = project.tasks.findByName("assembleProdRelease")
    val assembleDevReleaseTask = project.tasks.findByName("assembleDevRelease")

    // Debug tasks
    val assembleDebugTask = project.tasks.findByName("assembleDebug")
    val assembleProdDebugTask = project.tasks.findByName("assembleProdDebug")
    val assembleDevDebugTask = project.tasks.findByName("assembleDevDebug")

    // Check if the user explicitly requested any task containing 'prod'
    val requestedTasks = project.gradle.startParameter.taskNames
    val isProdRequested = requestedTasks.any { it.contains("prod", ignoreCase = true) }
    
    // --- 1. Task Dependency Fix (for both Debug and Release) ---
    // Problem: By default, 'assembleRelease' depends on ALL release flavor tasks ('assembleDevRelease', 'assembleProdRelease').
    // The same applies to 'assembleDebug'.
    // Solution: If the user didn't request a 'prod' flavor, we disable the prod tasks and remove them as dependencies.
    if (!isProdRequested) {
        if (assembleProdReleaseTask != null && assembleReleaseTask != null) {
            assembleProdReleaseTask.enabled = false
            val newDependencies = assembleReleaseTask.taskDependencies.getDependencies(assembleReleaseTask)
                .filter { it.name != assembleProdReleaseTask.name }
                .toSet()
            assembleReleaseTask.setDependsOn(newDependencies)
        }
        if (assembleProdDebugTask != null && assembleDebugTask != null) {
            assembleProdDebugTask.enabled = false
            val newDependencies = assembleDebugTask.taskDependencies.getDependencies(assembleDebugTask)
                .filter { it.name != assembleProdDebugTask.name }
                .toSet()
            assembleDebugTask.setDependsOn(newDependencies)
        }
        println("INFO: Disabling 'prod' tasks by default. Use --flavor=prod to build.")
    }

    // --- 2. APK Renaming Fix (for both Debug and Release) ---
    // Problem: Flavored builds create named APKs (e.g., 'app-dev-release.apk'), but the Flutter CLI
    // looks for generic names ('app-release.apk', 'app-debug.apk').
    // Solution: We add a 'doLast' action to the 'dev' task to copy and rename the file to the location Flutter expects.
    if (assembleDevReleaseTask != null) {
        assembleDevReleaseTask.doLast {
            val gradleApkDir = file("${project.buildDir}/outputs/apk/dev/release")
            val originalApk = file("${gradleApkDir}/app-dev-release.apk")
            val flutterOutputDir = file("${project.rootProject.buildDir}/app/outputs/flutter-apk")
            val targetApk = file("${flutterOutputDir}/app-release.apk")

            flutterOutputDir.mkdirs()
            if (originalApk.exists()) {
                originalApk.copyTo(targetApk, overwrite = true)
                println("INFO: Copied release APK to ${targetApk.absolutePath} for Flutter.")
            } else {
                println("WARN: Could not find release APK at: ${originalApk.absolutePath}.")
            }
        }
    }

    if (assembleDevDebugTask != null) {
        assembleDevDebugTask.doLast {
            val gradleApkDir = file("${project.buildDir}/outputs/apk/dev/debug")
            val originalApk = file("${gradleApkDir}/app-dev-debug.apk")
            val flutterOutputDir = file("${project.rootProject.buildDir}/app/outputs/flutter-apk")
            val targetApk = file("${flutterOutputDir}/app-debug.apk")

            flutterOutputDir.mkdirs()
            if (originalApk.exists()) {
                originalApk.copyTo(targetApk, overwrite = true)
                println("INFO: Copied debug APK to ${targetApk.absolutePath} for Flutter.")
            } else {
                println("WARN: Could not find debug APK at: ${originalApk.absolutePath}.")
            }
        }
    }

    if (assembleDevReleaseTask != null || assembleDevDebugTask != null) {
        println("INFO: Added post-build actions to rename APKs for Flutter compatibility.")
    }

}


flutter {
    source = "../.."
}
