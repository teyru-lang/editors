; Bracket matching for Teyru.  The pairs are the `@punctuation.bracket`
; literals of highlights.scm; the angle brackets of a type argument or a type
; parameter list are left out on purpose, because `<` and `>` are comparison
; operators too.
("{" @open "}" @close)
("[" @open "]" @close)
("(" @open ")" @close)
