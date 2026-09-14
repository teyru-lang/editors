package dev.teyru.idea;

import com.intellij.lang.Language;

/**
 * The Teyru language.
 *
 * <p>Nothing parses Teyru in the IDE: the plugin registers this language so that
 * {@link TeyruFileType} has a language to belong to and so that highlighting can
 * be attached to it, and the highlighting itself comes from the TextMate grammar
 * (see {@link TeyruTextMateBundleProvider}).
 */
public final class TeyruLanguage extends Language {

    public static final TeyruLanguage INSTANCE = new TeyruLanguage();

    private TeyruLanguage() {
        super("Teyru");
    }
}
