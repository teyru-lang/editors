# Teyru for the JetBrains IDEs

A plugin for IntelliJ IDEA and the other IntelliJ Platform IDEs. It registers
`.teyru` files as Teyru files and highlights them with the TextMate grammar that
ships with the language.

- `.teyru` files open as Teyru, with the comments, bracket pairs, auto-closing
  and indentation rules of `textmate/language-configuration.json`.
- Syntax highlighting comes from `textmate/teyru.tmLanguage.json`, the same
  grammar the VS Code extension uses.
- Nothing else: the Teyru compiler has no language server, so there is no
  completion, go-to-definition, rename, formatting or diagnostics here.

## Layout

```
build.gradle.kts                       the build (IntelliJ Platform Gradle Plugin 2.x)
settings.gradle.kts                    plugin versions and repositories
gradle.properties                      group and version
src/main/java/dev/teyru/idea/          TeyruLanguage, TeyruFileType, the TextMate bundle provider
src/main/resources/META-INF/plugin.xml id, name, vendor, dependencies, extension registrations
src/main/resources/textmate/           the grammar and the manifest the TextMate engine reads
```

## Build

The build needs a JDK 25: the IntelliJ Platform 2026.2 ships Java 25 class
files, so a lower `javac` cannot read them, and Gradle resolves the toolchain
from the JDKs installed on the machine. From this directory:

```sh
./gradlew buildPlugin
```

That writes the installable plugin to `build/distributions/`. To try the plugin
in a real IDE without packaging it:

```sh
./gradlew runIde
```

`./gradlew verifyPlugin` checks the plugin against the IntelliJ Platform
version it is built against.

## Install from disk

1. Build the plugin as above.
2. In the IDE: **Settings | Plugins | ⚙ | Install Plugin from Disk…**
3. Pick the ZIP from `build/distributions/`, restart the IDE, and open a
   `.teyru` file.

## The version it targets

`build.gradle.kts` builds against IntelliJ IDEA Community `2026.2.2`, and
`src/main/resources/META-INF/plugin.xml` declares `<idea-version since-build="262"
until-build="262.*"/>` to match. Raising the target means changing both: the
platform version in `build.gradle.kts` and the build numbers in `plugin.xml`.

Highlighting is the platform's bundled *TextMate Bundles* plugin
(`org.jetbrains.plugins.textmate`), which the plugin depends on: the
`textmate.bundleProvider` extension registers the grammar, and
`TextMateSyntaxHighlighterFactory` is what lexes a `.teyru` file with it.
