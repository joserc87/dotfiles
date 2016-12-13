" Vim syntax file
" Language: Spell
" Maintainer: José Ramón Cano Yribarren
" Latest Revision: 07 Dec 2016

"if exists("b:current_syntax")
"  finish
"endif

" KEYWORDS:

syn keyword spellStatement step nextgroup=spellStepName skipwhite
syn keyword spellStatement as nextgroup=spellAlias
syn keyword spellStatement when required goto

syn keyword spellControl label string email text date number checkbox list radio
syn keyword spellControl attachment image multi

syn keyword spellControl item

syn keyword spellOperator is not and or
syn keyword spellOperator -> == != =

syn match   spellComment "#.*$"
syn match   spellMetadata "$[a-zA-Z_][a-zA-Z0-9_]*"

syn keyword spellBoolean true false selected unselected

syn region spellStepName   start=+[bB]\='+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
syn region spellStepName   start=+[bB]\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell

syn match   spellAlias    "[a-zA-Z_][a-zA-Z0-9_]*"

" Strings
syn region spellString   start=+[bB]\='+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
syn region spellString   start=+[bB]\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
syn region spellString   start=+[bB]\="""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
syn region spellString   start=+[bB]\='''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell

" Syntax highlighting

let b:current_syntax = "spell"

hi def link spellStatement Statement
hi def link spellStepName Function
hi def link spellAlias Function
hi def link spellOperator Keyword
hi def link spellComment Comment
hi def link spellControl Type
hi def link spellString Constant
hi def link spellBoolean Boolean
hi def link spellMetadata Special
