"""""""""""""""
"" Basic
"""""""""""""""
if has("gui_macvim")
  set macmeta
  "set guifont=Meslo\ LG\ S\ DZ\ Regular\ Nerd\ Font\ Complete:h14

  " macVim 에서 esc 로 영문변환, imi 는 1 또는 2 로 설정해준다
  set noimd
  set imi=1
endif

set encoding=UTF-8

set nocompatible " 호환성 무시. 안해주면 대부분 플러그인이 설치가 안됨
set nofixeol " EOL을 vim이 고치지 못하게 함

set mouse=a " 모든 모드에서 마우스 사용

set backspace+=indent,eol,start " 백스페이스 사용
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab
set cindent autoindent smartindent
set langmap=ㅁa,ㅠb,ㅊc,ㅇd,ㄷe,ㄹf,ㅎg,ㅗh,ㅑi,ㅓj,ㅏk,ㅣl,ㅡm,ㅜn,ㅐo,ㅔp,ㅂq,ㄱr,ㄴs,ㅅt,ㅕu,ㅍv,ㅈw,ㅌx,ㅛy,ㅋz
set splitbelow
set splitright
set virtualedit=block   " visual block mode를 쓸 때 문자가 없는 곳도 선택 가능
set autoread
set list listchars=tab:·\ ,trail:·,extends:>,precedes:<
set smartcase ignorecase hlsearch incsearch
set nopaste " 붙여넣기 할 때 인덴트 유지

set noswapfile
set nobackup

"""""""""""""""
"" View
"""""""""""""""
set nu " 라인넘버 표시
set ruler " 커서 좌표 표시
set laststatus=2 " 상태바를 언제나 표시
set showmatch " 일치하는 괄호 하이라이팅
set cursorline " highlight current line
set lazyredraw " redraw only when we need to.

""""""""""""""""""""
"" Plugin Settings
""""""""""""""""""""

call plug#begin('$VIM/plugged')

  Plug 'vimwiki/vimwiki'
  
  " Tags
  " Plug 'vim-scripts/taglist.vim'
  " Plug 'majutsushi/tagbar' " 문서 요약 보여주기
  " Plug 'ludovicchabant/vim-gutentags' " 자동으로 tags 파일을 갱신
  
  " Plug 'jszakmeister/markdown2ctags', {'do' : 'cp ./markdown2ctags.py ~/.local/bin/markdown2ctags.py'}

  Plug ‘tpope/vim-fugitive’ " git

  " Files
  Plug 'scrooloose/nerdtree' " 소스트리
  Plug 'ryanoasis/vim-devicons'
  " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  " Plug 'junegunn/fzf.vim'
  " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " 퍼지 검색

  " Edit
  Plug 'tpope/vim-surround'
  Plug 'jiangmiao/auto-pairs' " 괄호 자동 닫기
  Plug 'vim-airline/vim-airline' " 하단 인터페이스 변경

  " View
  Plug 'luochen1990/rainbow' " 괄호를 level 별로 다르게 색칠
  Plug 'altercation/vim-colors-solarized' " 컬러스킴
  Plug 'mhinz/vim-startify' " 시작 화면을 꾸며준다. MRU가 있어 편리하다
  
  " Plug ‘plasticboy/vim-markdown’ " 마크다운
  " Plug ‘Lokaltog/vim-easymotion’ " 한 화면에서 커서 이동
  " Plug 'johngrib/vim-f-hangul' " vim 한글 검색
  " Plug ‘tommcdo/vim-lion’ " 라인정렬
  " Plug 'godlygeek/tabular' " 라인정렬
  " Plug ‘Valloric/YouCompleteMe’ " 자동완성
  " Plug ‘terryma/vim-multiple-cursors’ " 다중커서

call plug#end()

" Pathogen
"call pathogen#infect()
"syntax on
"filetype plugin indent on

" Theme
syntax enable
set background=dark
colorscheme solarized

" Nerdtree
let NERDTreeShowHidden=1


"""""""""""""""
" vimwiki
"""""""""""""""
let g:vimwiki_conceallevel = 0
let g:vimwiki_table_mappings = 0

" F4 키를 누르면 커서가 놓인 단어를 위키에서 검색한다.
nnoremap <F4> :execute "VWS /" . expand("<cword>") . "/" <Bar> :lopen<CR>

" Shift F4 키를 누르면 현재 문서를 링크한 모든 문서를 검색한다
nnoremap <S-F4> :execute "VWB" <Bar> :lopen<CR>

" 자주 사용하는 vimwiki 명령어에 단축키를 취향대로 매핑해둔다
let maplocalleader = "\`"
command! WikiIndex :VimwikiIndex
nmap <LocalLeader><LocalLeader> <Plug>VimwikiIndex
" nmap <LocalLeader>wi <Plug>VimwikiDiaryIndex
" nmap <LocalLeader>w<LocalLeader>w <Plug>VimwikiMakeDiaryNote
nmap <LocalLeader>wt :VimwikiTable<CR>


" 위키 파일 위치
let g:vimwiki_list = [
    \{
    \   'path': '/Volumes/Untitled/git/vimwiki', #'path': '~/vimwiki', iVim
    \   'ext' : '.md',
    \   'diary_rel_path': '.',
    \}
\]

" 메타데이터의 업데이트 시간 자동 갱신
function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        " echo('markdown updated time modified')
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun

autocmd BufWritePre *.md call LastModified()

" 새로운 마크다운 만들었을때 템플릿 자동 생성
function! NewTemplate()

    let l:wiki_directory = v:false

    for wiki in g:vimwiki_list
        if expand('%:p:h') . '/' == wiki.path
            let l:wiki_directory = v:true
            break
        endif
    endfor

    if !l:wiki_directory
        return
    endif

    if line("$") > 1
        return
    endif

    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'layout: post')
    call add(l:template, 'title: ')
    call add(l:template, 'excerpt: ')
    call add(l:template, 'categories: []')
    call add(l:template, 'tags: []')
    call add(l:template, 'parent  : ')
    call add(l:template, 'date: ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'updated: ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'comments: trie')
    call add(l:template, 'latex: false')
    call add(l:template, 'github: false')
    call add(l:template, 'gist: false')
    call add(l:template, 'mermaid: false')
    call add(l:template, '---')
    call add(l:template, '## 목차')
    call add(l:template, '')
    call add(l:template, '* 목차')
    call add(l:template, '{:toc}')
    call add(l:template, '')
    call add(l:template, '## ')
    call setline(4, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction

autocmd BufRead,BufNewFile *.md call NewTemplate()

" 그룹 등록

augroup vimwikiauto
    autocmd BufWritePre *wiki/*.md call LastModified()
    autocmd BufRead,BufNewFile *wiki/*.md call NewTemplate()
augroup END

let g:md_modify_disabled = 0
