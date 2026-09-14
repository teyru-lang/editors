; Outline for Teyru: everything that has a name to show in the outline panel.
; Zed nests the items itself, from the tree.
(package_declaration
  name: (scoped_identifier) @name) @item

(class_declaration
  name: (identifier) @name) @item

(interface_declaration
  name: (identifier) @name) @item

(annotation_type_declaration
  name: (identifier) @name) @item

(record_declaration
  name: (identifier) @name) @item

(enum_declaration
  name: (identifier) @name) @item

(enum_constant
  name: (identifier) @name) @item

(method_declaration
  name: (identifier) @name) @item

(constructor_declaration
  name: (identifier) @name) @item

(compact_constructor_declaration
  name: (identifier) @name) @item

(field_declaration
  declarator: (variable_declarator
    name: (identifier) @name)) @item
