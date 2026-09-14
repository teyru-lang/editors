package dev.teyru.idea;

import com.intellij.openapi.fileTypes.LanguageFileType;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.Icon;

/**
 * The {@code .teyru} file type, registered in {@code META-INF/plugin.xml}.
 *
 * <p>The name must stay in step with the {@code name} attribute of that
 * registration, and {@link #getLanguage()} with its {@code language} attribute.
 */
public final class TeyruFileType extends LanguageFileType {

    public static final TeyruFileType INSTANCE = new TeyruFileType();

    private TeyruFileType() {
        super(TeyruLanguage.INSTANCE);
    }

    @Override
    public @NotNull String getName() {
        return "Teyru";
    }

    @Override
    public @NotNull String getDescription() {
        return "Teyru source file";
    }

    @Override
    public @NotNull String getDefaultExtension() {
        return "teyru";
    }

    @Override
    public @Nullable Icon getIcon() {
        return null;
    }
}
