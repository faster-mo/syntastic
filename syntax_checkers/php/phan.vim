"============================================================================
"File:        phan.vim
"Description: Syntax checking plugin for syntastic.vim using phan
"Maintainer:  Andrew S. Morrison <asm at etsy dot com>
"License:     MIT
"============================================================================

if exists('g:loaded_syntastic_php_phan_checker')
    finish
endif
let g:loaded_syntastic_php_phan_checker = 1

if !exists('g:syntastic_php_phan_sort')
    let g:syntastic_php_phan_sort = 1
endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_php_phan_IsAvailable() dict
    return executable(self.getExec())
endfunction

function! SyntaxCheckers_php_phan_GetHighlightRegex(item)
    if match(a:item['text'], 'assigned but unused variable') > -1
        let term = split(a:item['text'], ' - ')[1]
        return '\V\\<'.term.'\\>'
    endif

    return ''
endfunction

function! SyntaxCheckers_php_phan_GetLocList() dict
    let args = ""
    if len(glob(g:phpqa_phan_config))>0
        let args = "-k ".g:phpqa_phan_config. " --no-progress-bar -I"
        " let args = "-l . -k ".g:phpqa_phan_config." --include-analysis-file-list "
    endif

    let makeprg = self.makeprgBuild({
                \ 'args': args })

    let errorformat = '%f:%l\ Phan%m'
    let env = { }
    return SyntasticMake({
                \ 'makeprg': makeprg,
                \ 'errorformat': errorformat,
                \ 'env': env })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
            \ 'filetype': 'php',
            \ 'name': 'phan'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
