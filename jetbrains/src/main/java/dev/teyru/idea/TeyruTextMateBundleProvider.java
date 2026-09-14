package dev.teyru.idea;

import com.intellij.openapi.application.PathManager;
import com.intellij.openapi.diagnostic.Logger;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.plugins.textmate.api.TextMateBundleProvider;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * Hands the bundled TextMate grammar to the TextMate plugin.
 *
 * <p>Without this registration nothing ever tells the TextMate engine about
 * {@code source.teyru}, so {@code TextMateService.getLanguageDescriptorByFileName}
 * finds no descriptor for a {@code .teyru} file and every file opens as
 * undifferentiated text. The registrations in {@code plugin.xml} only decide
 * <em>how</em> a grammar is lexed; this is what makes one apply.
 *
 * <p>The engine reads bundles from the file system, while the grammar ships inside
 * the plugin jar, so the resources below are unpacked into the IDE's system
 * directory on first use. An unchanged file is left alone, which is what keeps
 * the directory usable across plugin upgrades.
 */
public final class TeyruTextMateBundleProvider implements TextMateBundleProvider {

    private static final Logger LOG = Logger.getInstance(TeyruTextMateBundleProvider.class);

    /** The bundle's name in <i>Settings | Editor | TextMate Bundles</i>. */
    private static final String BUNDLE_NAME = "Teyru";

    /**
     * Classpath resource to its path inside the unpacked bundle directory.
     *
     * <p>{@code package.json} is what makes the TextMate engine treat the directory
     * as a VS Code style bundle, and its {@code contributes} section is what ties
     * the grammar to the {@code .teyru} extension.
     */
    private static final Map<String, String> BUNDLE_FILES = Map.of(
            "textmate/package.json", "package.json",
            "textmate/language-configuration.json", "language-configuration.json",
            "textmate/teyru.tmLanguage.json", "teyru.tmLanguage.json");

    @Override
    public @NotNull List<PluginBundle> getBundles() {
        Path directory = unpackBundle();
        return directory == null ? List.of() : List.of(new PluginBundle(BUNDLE_NAME, directory));
    }

    /**
     * Writes {@link #BUNDLE_FILES} into the IDE system directory, returning that
     * directory, or {@code null} when a resource is missing or cannot be written.
     */
    private static Path unpackBundle() {
        Path directory = Path.of(PathManager.getSystemPath(), "teyru", "textmate");
        try {
            for (Map.Entry<String, String> file : BUNDLE_FILES.entrySet()) {
                byte[] bytes = readResource(file.getKey());
                if (bytes == null) {
                    // A mis-packaged plugin. Warn rather than fail: an exception here
                    // would abort the loading of every other TextMate bundle too.
                    LOG.warn("The Teyru TextMate bundle resource '" + file.getKey()
                            + "' is missing from the plugin, so .teyru files will open "
                            + "without syntax highlighting.");
                    return null;
                }
                Path target = directory.resolve(file.getValue());
                Files.createDirectories(target.getParent());
                if (Files.exists(target) && Arrays.equals(Files.readAllBytes(target), bytes)) {
                    continue;
                }
                // Two IDEs sharing this system directory can unpack at the same time
                // after an upgrade. Write beside the target and move it into place, so
                // a concurrent reader never sees a half-written grammar.
                Path staged = Files.createTempFile(target.getParent(), ".teyru", ".tmp");
                try {
                    Files.write(staged, bytes);
                    Files.move(staged, target, StandardCopyOption.REPLACE_EXISTING);
                } finally {
                    Files.deleteIfExists(staged);
                }
            }
            return directory;
        } catch (IOException e) {
            LOG.warn("Cannot unpack the Teyru TextMate bundle into " + directory, e);
            return null;
        }
    }

    private static byte[] readResource(String resource) {
        try (InputStream stream = TeyruTextMateBundleProvider.class.getClassLoader()
                .getResourceAsStream(resource)) {
            return stream == null ? null : stream.readAllBytes();
        } catch (IOException e) {
            LOG.warn("Cannot read the Teyru TextMate bundle resource '" + resource + "'", e);
            return null;
        }
    }
}
