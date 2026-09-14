; Injections for Teyru.
;
; Teyru has no embedded language: a string, a text block and a comment are plain
; text, and the grammar has no sub-grammar for any of them.  Comments are the
; one case worth handing over -- Zed's `comment` language is what colours and
; spell checks the prose inside a comment.
((line_comment) @injection.content
  (#set! injection.language "comment"))

((block_comment) @injection.content
  (#set! injection.language "comment"))
