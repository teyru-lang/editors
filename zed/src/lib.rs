//! Teyru support for Zed.
//!
//! Everything this extension does is declarative: the grammar is registered in
//! `extension.toml`, and the language configuration and the queries live under
//! `languages/teyru/`.  There is no language server to start, because the Teyru
//! compiler does not have one, so this crate has no state and nothing to do at
//! runtime.  It exists because a Zed extension is a Rust crate, and because
//! that is where a language server would be wired up once there is one.

use zed_extension_api as zed;

struct TeyruExtension;

impl zed::Extension for TeyruExtension {
    fn new() -> Self {
        TeyruExtension
    }
}

zed::register_extension!(TeyruExtension);
