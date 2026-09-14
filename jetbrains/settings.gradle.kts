import org.jetbrains.intellij.platform.gradle.extensions.intellijPlatform

rootProject.name = "teyru-jetbrains"

pluginManagement {
    plugins {
        id("org.jetbrains.intellij.platform") version "2.19.0"
    }
}

plugins {
    id("org.jetbrains.intellij.platform.settings") version "2.19.0"
}

dependencyResolutionManagement {
    repositories {
        mavenCentral()

        // The IntelliJ Platform artifacts live in JetBrains' own repositories.
        intellijPlatform {
            defaultRepositories()
        }
    }
}
