; Highlighting for Teyru in Zed.
;
; This is `tree-sitter-teyru/queries/highlights.scm` with the capture names
; changed to the ones Zed's themes define: `@comment.documentation` became
; `@comment.doc`, `@function.method*` became `@function`, `@variable.member`
; became `@property` and `@variable.builtin` became `@variable.special`.  The
; patterns themselves did not move, so the notes below still hold.
;
; Every node name below comes from a real parse (`tree-sitter parse` on
; tests/programs and lib).  Teyru has no `type_identifier`: a type is a
; `scoped_identifier`, so the capital-letter heuristic that nvim-treesitter
; uses for Java is used here too, and a few contextual words (`var`, `val`,
; `field`, `value`) are matched by text because the lexer emits them as plain
; identifiers and the parser decides their role from context.

; --------------------------------------------------------------- comments

[
  (line_comment)
  (block_comment)
] @comment @spell

((block_comment) @comment.doc
  (#match? @comment.doc "^/\\*\\*[^*]"))

((line_comment) @comment.doc
  (#match? @comment.doc "^///[^/]"))

; ----------------------------------------------------------- declarations

(class_declaration
  name: (identifier) @type)

(interface_declaration
  name: (identifier) @type)

(annotation_type_declaration
  name: (identifier) @type)

(record_declaration
  name: (identifier) @type)

(enum_declaration
  name: (identifier) @type)

(constructor_declaration
  name: (identifier) @type)

(compact_constructor_declaration
  name: (identifier) @type)

(method_declaration
  name: (identifier) @function)

(annotation_method_declaration
  name: (identifier) @function)

(method_invocation
  name: (identifier) @function)

(method_reference
  name: (identifier) @function)

(constructor_invocation
  name: [
    "super"
    "this"
  ] @function.builtin)

; a new instance is a constructor call, and the type is its name
(object_creation_expression
  type: (scoped_identifier) @constructor)

(inner_class_creation
  name: (identifier) @constructor)

; ----------------------------------------------------------------- names

; `A.B.C` in type position; a lowercase name is a package or a value
((scoped_identifier
  (identifier) @type)
  (#match? @type "^[A-Z]"))

((identifier) @type
  (#match? @type "^[A-Z][A-Za-z0-9_]*$"))

; CONSTANT_CASE is a constant, and so is every enum constant
((identifier) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]+$"))

(enum_constant
  name: (identifier) @constant)

; ------------------------------------------------------------------ fields

(field_declaration
  declarator: (variable_declarator
    name: (identifier) @property))

(field_access
  field: (identifier) @property)

(field_access
  object: (identifier) @type
  (#match? @type "^[A-Z]"))

(method_invocation
  object: (identifier) @type
  (#match? @type "^[A-Z]"))

(method_reference
  object: (identifier) @type
  (#match? @type "^[A-Z]"))

; Teyru properties: the accessor blocks that follow a field, and the `field`
; and `value` words the getter and setter are written against.  The parser
; sees them as ordinary identifiers, so they are matched by text; inside a
; get/set block that is what they mean.
(accessor_block
  "{" @punctuation.bracket
  "}" @punctuation.bracket)

(accessor
  [
    "get"
    "set"
  ] @keyword)

((identifier) @variable.special
  (#eq? @variable.special "field"))

((identifier) @variable.parameter
  (#eq? @variable.parameter "value"))

; ------------------------------------------------------------- parameters

(formal_parameter
  name: (identifier) @variable.parameter)

(setter_parameter
  name: (identifier) @variable.parameter)

(catch_clause
  name: (identifier) @variable.parameter)

(enhanced_for_statement
  name: (identifier) @variable.parameter)

(resource
  declarator: (variable_declarator
    name: (identifier) @variable.parameter))

(inferred_parameters
  (identifier) @variable.parameter)

(lambda_expression
  parameters: (identifier) @variable.parameter)

(type_parameter
  name: (identifier) @type)

; ------------------------------------------------------------- patterns

(type_pattern
  name: (identifier) @variable.parameter)

(record_pattern
  type: [
    (identifier)
    (scoped_identifier)
  ] @type)

(pattern
  name: (identifier) @variable.parameter)

; --------------------------------------------------------------- labels

(labeled_statement
  label: (identifier) @label)

(break_statement
  label: (identifier) @label)

(continue_statement
  label: (identifier) @label)

; ------------------------------------------------------------ annotations

(annotation
  "@" @attribute)

(annotation
  name: (scoped_identifier) @attribute)

(annotation
  name: (scoped_identifier
    (identifier) @attribute))

(annotation_argument
  name: (identifier) @variable.parameter)

; --------------------------------------------------------------- literals

(string_literal) @string

; a text block is a string that may span lines
(text_block) @string

(character_literal) @string.special

[
  (decimal_integer_literal)
  (hex_integer_literal)
  (binary_integer_literal)
] @number

(decimal_floating_point_literal) @number

[
  (true)
  (false)
] @boolean

(null_literal) @constant.builtin

[
  (primitive_type)
] @type.builtin

(this_expression) @variable.special

(super_expression) @variable.special

; --------------------------------------------------------------- keywords

[
  "assert"
  "case"
  "default"
  "instanceof"
  "permits"
  "record"
  "sealed"
  "non-sealed"
] @keyword

[
  "class"
  "enum"
  "interface"
] @keyword

(annotation_type_declaration
  "@" @keyword
  "interface" @keyword)

; `default` in an `@interface` body is a modifier, not a case label
(annotation_method_declaration
  "default" @keyword)

[
  "abstract"
  "final"
  "native"
  "private"
  "protected"
  "public"
  "static"
  "strictfp"
  "transient"
  "volatile"
  "synchronized"
] @keyword

(static_initializer
  "static" @keyword)

[
  "return"
  "yield"
] @keyword

[
  "try"
  "catch"
  "finally"
  "throw"
  "throws"
] @keyword

[
  "if"
  "else"
  "switch"
  "when"
] @keyword

(ternary_expression
  [
    "?"
    ":"
  ] @keyword)

[
  "for"
  "while"
  "do"
  "break"
  "continue"
] @keyword

[
  "import"
  "package"
] @keyword

(import_declaration
  "module" @keyword)

"new" @keyword

; `var` and `val` are inference markers: the parser reads them as type names
; (`ast.TypeExpr` with Name "var"/"val") and semantic analysis draws the
; conclusion, so as far as the tree goes they are identifiers that only appear
; in type position.  Matching by text is the only handle there is.
((identifier) @keyword
  (#any-of? @keyword "var" "val"))

; ------------------------------------------------------------- operators

[
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "|="
  "^="
  "<<="
  ">>="
  ">>>="
  "->"
] @operator

[
  "!"
  "~"
  "+"
  "-"
  "*"
  "/"
  "%"
  "++"
  "--"
  "&"
  "&&"
  "|"
  "||"
  "^"
  "=="
  "!="
  "<"
  "<="
  ">"
  ">="
  "<<"
  ">>"
  ">>>"
] @operator

; ------------------------------------------------------------- punctuation

[
  "."
  ","
  "..."
  "::"
] @punctuation.delimiter

; the `:` of a for header, of a label, of a `case` that falls through and of
; an `assert` message; Teyru has no semicolons, so there is no `;` here
[
  (for_statement ":")
  (enhanced_for_statement ":")
  (labeled_statement ":")
  (assert_statement ":")
] @punctuation.delimiter

(switch_rule
  ":" @punctuation.delimiter)

[
  "{"
  "}"
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

(type_arguments
  [
    "<"
    ">"
  ] @punctuation.bracket)

(type_parameters
  [
    "<"
    ">"
  ] @punctuation.bracket)

(array_type
  [
    "["
    "]"
  ] @punctuation.bracket)
