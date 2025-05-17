function! s:checkJobFeature() abort
    if !has('nvim') && !has('job')
        call luaeval("vim.health.error('Not supported: not nvim nor vim with +job.')")
    endif
endfunction

function! s:checkBinary() abort
    let l:path = LanguageClient#binaryPath()
    if executable(l:path) ==# 1
        call luaeval("vim.health.ok('binary found: ' .. _A)", l:path)
    else
        call luaeval("vim.health.error(
                    \ "binary is missing or not executable. " ..
                    \ "Try reinstall it with install.sh or install.ps1: " ..
                    \ .._A)", l:path)
    endif

    let output = substitute(system([l:path, '--version']), '\n$', '', '')
    call luaeval("vim.health.ok(_A)", output)
endfunction

function! s:checkFloatingWindow() abort
    if !exists('*nvim_open_win')
        call luaeval("vim.health.info('Floating window is not supported. Preview window will be used for hover')")
        return
    endif
    call luaeval("vim.health.ok('Floating window is supported and will be used for hover')")
endfunction

function! health#LanguageClient#check() abort
    call s:checkJobFeature()
    call s:checkBinary()
    call s:checkFloatingWindow()
endfunction
