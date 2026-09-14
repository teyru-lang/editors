# Teyru editors

Editor support and the tree-sitter grammar for Teyru, the Java-shaped language
whose compiler turns `.teyru` source files into native binaries. The compiler,
its documentation and its standard library live in
[teyru-lang/Teyru](https://github.com/teyru-lang/Teyru).

```
vscode/             VS Code extension: TextMate grammar and snippets
zed/                Zed extension: the tree-sitter grammar and its queries
jetbrains/          JetBrains IDE plugin: file type and TextMate highlighting
tree-sitter-teyru/  the tree-sitter grammar, used by Zed, Neovim and Helix
```

Teyru source files use the `.teyru` extension everywhere.

## VS Code

`vscode/` is a VS Code extension: TextMate highlighting for the language as this
project's compiler accepts it, bracket and comment behaviour, and snippets for
the declarations. From that directory:

```sh
npx --yes @vscode/vsce package --out /tmp/teyru-0.1.0.vsix
code --install-extension /tmp/teyru-0.1.0.vsix
```

It is not on the Marketplace. `vscode/README.md` says what the grammar covers
and what it deliberately does not.

## Zed

`zed/` is a Zed extension. Zed builds the extension and the grammar itself, so
there is nothing to compile by hand:

1. Install Rust with [rustup](https://www.rust-lang.org/tools/install).
2. In Zed, open the Extensions page and run **Install Dev Extension**.
3. Pick the `zed/` directory of a checkout.

The extension is not in Zed's extension registry, so the dev-extension route is
the only way to install it. It registers `source.teyru` through
`tree-sitter-teyru/` in this repository, and the highlighting, bracket, outline
and comment queries under `zed/languages/teyru/`.

## JetBrains IDEs

`jetbrains/` is an IntelliJ Platform plugin: `.teyru` files open as Teyru files
and are highlighted with the TextMate grammar of the VS Code extension. It needs
JDK 21, and from that directory:

```sh
cd jetbrains
./gradlew buildPlugin
```

Then install the ZIP from `build/distributions/` with
**Settings | Plugins | ⚙ | Install Plugin from Disk…**, and restart the IDE.
`./gradlew runIde` opens a sandbox IDE with the plugin in it instead.
`jetbrains/README.md` has the details, including the IntelliJ Platform version
the plugin is built against.

## tree-sitter grammar

`tree-sitter-teyru/` is the grammar, with the generated parser checked in and
the corpus tests beside it. `tree-sitter-teyru/README.md` describes how to use
it from Neovim, from Helix and from the `tree-sitter` CLI, what it covers, and
the three shapes of Teyru source it deliberately reads differently from the
compiler.

## No language server yet

There is no language server for Teyru: the compiler has no LSP as of now, which
is why none of the editors above offers completion, go-to-definition, rename,
hover, formatting, refactoring or diagnostics. What they offer is highlighting
from a grammar -- TextMate in VS Code and in the JetBrains IDEs, tree-sitter in
Zed as well as in Neovim and Helix -- plus whatever the editor can do with that:
bracket matching, code folding, comments and snippets. `zed/` is where a Teyru
LSP would be wired up once there is one.

## License

GPL-2.0-only, the license of the Teyru project. The third-party notices for the
whole project, including the tree-sitter headers copied into the grammar, are
kept by the compiler repository in
[THIRD-PARTY-NOTICES.md](https://github.com/teyru-lang/Teyru/blob/main/THIRD-PARTY-NOTICES.md).
