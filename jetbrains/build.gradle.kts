plugins {
    id("java")
    id("org.jetbrains.intellij.platform")
}

dependencies {
    intellijPlatform {
        // IntelliJ IDEA Community stopped being published as its own artifact in
        // 2025.3; `intellijIdea` is the distribution the platform plugin wants now.
        intellijIdea("2026.2.2")

        // The TextMate engine is a bundled plugin, and the highlighter
        // registrations in plugin.xml point at classes inside it.
        bundledPlugin("org.jetbrains.plugins.textmate")
    }
}

java {
    toolchain {
        // The IntelliJ Platform 2026.2 ships Java 25 class files, and javac
        // refuses to read them from a lower release level.
        languageVersion = JavaLanguageVersion.of(25)
    }
}

intellijPlatform {
    pluginConfiguration {
        // Mirrors <idea-version> in plugin.xml: the build rewrites that element
        // from here, and would otherwise patch the upper bound away.
        ideaVersion {
            sinceBuild = "262"
            untilBuild = "262.*"
        }
    }
}
