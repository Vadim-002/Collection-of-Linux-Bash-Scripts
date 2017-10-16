"personal setting"
set nu
set sm
set ai
set hlsearch
set ts=4
set expandtab
set autoindent
set ignorecase
set cursorline
syntax on


autocmd BufNewFile *.sh exec ":call SetTitle()"
func SetTitle()
        if expand("%:e") == 'sh'
                call setline(1,"#!/bin/bash") 
                call setline(2,"#") 
                call setline(3,"#********************************************************************") 
                call setline(4,"#Author:        xiaoshuaigege") 
                call setline(5,"#github:        xiaoshuaigege") 
                call setline(6,"#Date:          ".strftime("%Y-%m-%d"))
                call setline(7,"#FileName：     ".expand("%"))
                call setline(8,"#URL:           http://www.pojun.tech")
                call setline(9,"#Description：      The test script") 
                call setline(10,"#Copyright (C):    ".strftime("%Y")." All rights reserved")
                call setline(11,"#License:        GPL") 
                call setline(12,"#********************************************************************") 
                call setline(13,"") 
        endif
endfunc
autocmd BufNewFile * normal G
