"wangzhiyun vim setting

"判定当前操作系统类型
if has("win32") || has("win32unix")||has("win64")
    let g:OS#name = "win"
    let g:OS#win = 1
    let g:OS#mac = 0
    let g:OS#unix = 0
elseif has("mac")
    let g:OS#name = "mac"
    let g:OS#mac = 1
    let g:OS#win = 0
    let g:OS#unix = 0
elseif has("unix")
    let g:OS#name = "unix"
    let g:OS#unix = 1
    let g:OS#win = 0
    let g:OS#mac = 0
endif
if has("gui_running")
    let g:OS#gui = 1
else
    let g:OS#gui = 0
endif

"设置用户路径
if g:OS#win
    source $VIMRUNTIME/mswin.vim
    behave mswin
    let $VIMFOLDER = $VIM.'/vimfiles'
	let $VIMFILE = $VIM.'/_vimrc'
	let $WORK = 'D:/work/server'
elseif g:OS#unix
    let $VIMFOLDER = $HOME.'~/.vim'
	let $VIMFILE = $VIM.'/vimrc'
elseif g:OS#mac
    let $VIMFOLDER = $HOME.'/.vim'
	let $VIMFILE = $VIM.'/vimrc'
	let $GVIMFILE = $VIM.'/gvimrc'
    let $WORK = $HOME.'work/server'
endif
let $MySetFile= $VIMFOLDER.'mysetting/mysetting.vim'

"名词设定
let g:Author="WangZhiyun"
"setting======================================================
set autochdir
set autoread

"config ui_begin***************************************
set number											"显示行号
set laststatus=2									  "启用状态栏信息
set cmdheight=2									   "设置命令行的高度为2，默认为1
set cursorline										"突出显示当前行
set nowrap											"设置不自动换行
set shortmess=atI									 "去掉欢迎界面
set equalalways
set eadirection=

"encoding
set encoding=utf-8
set fileencoding=gbk
"set fileencoding=utf-8
set fileencodings=utf-8,gbk

"indent and fold 
set smartindent									   "启用智能对齐方式
"set noexpandtab										 "将Tab键转换为空格
set expandtab										 "将Tab键转换为空格
set tabstop=4										 "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4									  "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab										  "指定按一次backspace就删除shiftwidth宽度

" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

"导入变量
"python << EOF
"import cachesearch 
"from vimenv import env
"EOF

"文件头添加注释
autocmd BufNewFile *.py,*.java exec ":call SetTitle()"

function! WriteTitle(tInfo,lineno)
	let iLine=a:lineno
	for sInfo in a:tInfo
		call append(iLine,sInfo)
		let iLine+=1
	endfor
	call append(iLine,"")
endfunction

function! SetTitle()
	let tInfo=[]
	let iLine=0
	if &filetype=="python"
		call setline(1,"\# -*- coding: utf-8 -*-")
		let iLine=1
		call add(tInfo,"\#===================================")
		call add(tInfo,"\# Author	:".g:Author)
		call add(tInfo,"\# Create	:".strftime("%Y-%m-%d %H:%M:%S"))
		call add(tInfo,"\#===================================")
	elseif &filetype=="java"
		call setline(1,"\//===================================")
		let iLine=1
		call add(tInfo,"\// Author	:".g:Author)
		call add(tInfo,"\// Create	:".strftime("%Y-%m-%d %H:%M:%S"))
		call add(tInfo,"\//===================================")
	else
		call setline(1,"newtype ".&filetype)
	endif
	call WriteTitle(tInfo,iLine)
endfunction

function! AddModifyTime()
	let iCurLine=line(".")
	if iCurLine>0
		let iCurLine=iCurLine-1
	else
		let iCurLine=iCurLine
	endif
	let sTime="\# ModifyTime:".strftime("%Y-%m-%d %H:%M:%S")
	call append(iCurLine,sTime)
	"let sAuthor="\# Author	:".g:Author
	"call append(iCurLine+1,sAuthor)
	execute("w!")
endfunction

function! SetAddPrintText()
	let g:CurFileType=expand("%:e")
	if expand("%:e") == "py"
		let g:PrintText="print \"wzytxt=\""
	elseif expand("%:e") == "java"
		let g:PrintText="System.out.println(\"HelloWorld\")"
	else
		let g:PrintText="cur filetype no define!!!! ".g:CurFileType
	endif
	"call append(iCurLine,sText)
endfunction

function! AddPrintText()
	let iCurLine=line(".")
	let sText="no define!! ".expand("%:e")
	if expand("%:e") == "py"
		let sText="print \"wzytxt=\""
	endif
	call append(iCurLine,sText)
endfunction

function! F5Func()
	if expand("%:e")==#"py"
		call Execmd("python " . expand("%") . " 2>>" . g:g_SysEffqf,3)
	else
		call Execmd(expand("%:r") . ".exe" . " 2>>" . g:g_SysEffqf,3)
	endif
endfunction

function! RenameCurFile(sNew)
	execute("cd " . expand("%:p:h"))
	call rename(expand("%:t"),a:sNew)
	let iBNum=bufnr("")
	execute("edit " . a:sNew)
	execute(iBNum . "bd")
endfunction

function! DelCurFile()
	let sBName=bufname("%")
	let sAnwer=input('you will delete ' . sBName . '(y/n)')
	if sAnwer!=#'y'
		return
	endif
	let sPath=fnamemodify(sBName,":p")
	let sCMD=$VIMRUNTIME . "\\Recycle.exe " . sPath
	call Execmd(sCMD)
	let iBNum=bufnr("%")
	execute(iBNum . "bd")
endfunction

"去除PEP8的效果
function! AntiPEP8()
    for sSign in ['==','+','-','\*','\/','!=','\/=','\*=','+=','-=','=']
        execute("\%s/ ".sSign." /".sSign."/g")
    endfor
    for sSign in [',',]
        execute("\%s/".sSign." /".sSign."/g")
    endfor
endfunction

"定义FormartSrc()
function! FormartSrc()
    exec "w"
    if &filetype == 'c'
        exec "!astyle --style=ansi --one-line=keep-statements -a --suffix=none %"
    elseif &filetype == 'cpp' || &filetype == 'hpp'
        exec "r !astyle --style=ansi --one-line=keep-statements -a --suffix=none %> /dev/null 2>&1"
    elseif &filetype == 'perl'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'py'||&filetype == 'python'
        exec "r !autopep8 -i --aggressive %"
    elseif &filetype == 'java'
        exec "!astyle --style=java --suffix=none %"
    elseif &filetype == 'jsp'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'xml'
        exec "!astyle --style=gnu --suffix=none %"
    endif
    "exec "e! %"
endfunction
"结束定义FormartSrc

function! InsertTxtPEP8()
	let iCurLine=line(".")
    if (&filetype=="py"||&filetype=="python")&&(iCurLine!=0&&g:startinsertline!=0)
        let sExe='Autopep8 --range '.g:startinsertline.' '.iCurLine
        execute(sExe)
        echo sExe
    endif
endfunction

let g:startinsertline=0
function! StartInsert()
    let g:startinsertline=line('.')
endfunction

function! EndInsert()
    "call InsertTxtPEP8()
    let g:startinsertline=0
endfunction


if g:OS#win
    autocmd InsertLeave * call EndInsert()
    autocmd InsertEnter * call StartInsert()
endif

"keymap================================================================================
"文件
nnoremap <leader>ov :e $VIMFILE<cr>
nnoremap <leader>op :e $VIM/userdata/pros<cr>
nnoremap <leader>om :e $MySetFile<cr>
nnoremap <leader>oa :e $VIMFILE<cr>:vs $MySetFile<cr>
nnoremap <leader>ua :source $VIMFILE<cr>:source $MySetFile<cr>
nnoremap <leader>ec :execute("vsplit " . $VIM . '\vimfiles\colors\health.vim')<CR> 
nnoremap <leader>em :messages<cr>
nnoremap <leader>es :execute("vsplit " . $VIM . '\vimfiles\UltiSnips\all.snippets')<CR>
nnoremap <leader>et :vsplit E:\work\pypy\test.py<cr>

"输入
nnoremap <leader>at :call AddModifyTime()<cr>
"nnoremap <leader>ad oprint "wzytxt=",
nnoremap <leader>ad :call SetAddPrintText()<cr>oprint "test".g:PrintText
nnoremap <leader>dd :g/^.*print\ "wzytxt=.*$/d<cr>
nnoremap <leader><leader>a :call AntiPEP8()<cr>

"执行
nnoremap <F5> :call F5Func()<cr>

"map
nnoremap <leader>ss :execute("w\|source " . expand("%:p"))<CR> "保存加载当前文件

nnoremap L $
nnoremap H ^
vnoremap L $
vnoremap H ^
nnoremap <A-w> :wq!<cr>
vnoremap <A-w> :wq!<cr>

nnoremap <A-Right> :vertical res +1\|set winfixwidth<cr>
nnoremap <A-Left> :vertical res -1\|set winfixwidth<cr> 
nnoremap <A-Up> :res -1\|set winfixheight<cr>
nnoremap <A-Down> :res +1\|set winfixheight<cr>

nnoremap <F12> :!start explorer /select, %:p<cr>
nnoremap <F11> :NERDTreeFind<cr>
nnoremap <leader><Leader>n :call RenameCurFile("<C-R>=expand("%:t")<CR>")
nnoremap <leader><Leader>d :call DelCurFile()<cr>
nnoremap <leader>y ^vg_"*y 
nnoremap <leader>w viw"*y
vnoremap <leader>y "*y
nnoremap <leader><leader>y ^vg_"*y:stop<cr> 
vnoremap <leader><leader>y "*y:stop<cr>

nnoremap <c-k> <c-w>k
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

nmap <c-s-left> <c-pageup>
nmap <c-s-right> <c-pagedown>

inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

"use imap do not need type cr when complete 
imap <c-k> <Up>
imap <c-j> <Down>
imap <c-h> <Left>
imap <c-l> <Right>

