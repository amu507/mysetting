"wangzhiyun vim setting

"判定当前操作系统类型
"start_init========================================================
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
	let $VIMFOLDER = $VIM.'\vimfiles'
	let $BUNDLE = $VIMFOLDER.'\bundle'
	let $VIMFILE = $VIM.'\_vimrc'
	let $MYSETTING = $BUNDLE.'\mysetting\plugin\mysetting.vim'
	let $WORK = 'D:\work'
	let g:g_PathSplit="\\"
else
	let $VIM = $HOME.'/.vim'
	let $VIMFOLDER = $HOME.'/.vim'
	let $BUNDLE = $VIMFOLDER.'/bundle'
	let $VIMFILE = $VIM.'/gvimrc'
	let $MYSETTING = $BUNDLE.'/mysetting/plugin/mysetting.vim'
	let $WORK = $HOME.'/work'
	let g:g_PathSplit="/"
endif
let $PROJ = $WORK.g:g_PathSplit.'project'
let $PUBL = $WORK.g:g_PathSplit.'publish'
let $NOTE = $WORK.g:g_PathSplit.'note'
let $PRIV = $WORK.g:g_PathSplit.'private'
let $OPEN = $WORK.g:g_PathSplit.'opensource'

"start_readpros============================================================================================================
let mapleader = "-"
let g:g_DataPath=$VIM . g:g_PathSplit . "userdata"
let g:g_FixBuff=['sys.effqf','NERD_tree','-MiniBufExplorer-','__Tag_List__']
let g:g_LastWinr=-1
let g:g_BufHis=[]
let g:g_BufHisIdx=-1
let g:g_InBufHis=0

let g:g_MFSession=g:g_DataPath .g:g_PathSplit. 'mysession.vim'
let g:g_EffqfName="sys.effqf"
let g:g_SysEffqf=g:g_DataPath .g:g_PathSplit. g:g_EffqfName
let g:g_ProPaths={}
let g:g_ProPathList=[]
let g:g_ProExts={}
let g:g_ProIgnores={}
let g:g_CurPro=""
let g:g_Pro2DB={}
let g:g_UseCS=0
let g:SuperTabDefaultCompletionType="context"

function! ReadPros()
	let sEval="" 
	let sGval=""
	for sLine in readfile(g:g_DataPath .g:g_PathSplit. 'pros')
		"transform encoding
		"let sLine=iconv(sLine,"gbk","utf-8")
		if len(sLine)==#0||sLine[0]=='#'
			continue
		endif
		if sLine[0]==#'&'
			if len(sGval)!=#0
				let sEXE="let g:" . sGval . "=eval(\"" . sEval . "\")"
				execute(sEXE)
			endif
			let sEval=""
			let sGval=sLine[1:-1]
		else
			let sEval=sEval . sLine
		endif
	endfor
endfunction
call ReadPros()

function! Execmd(sCMD,...)
	let iMode=get(a:000,0,0)
	"no window,no wait
	if iMode==0
		let sEXE='silent !start /b cmd /c "'
		let sEXE=sEXE . a:sCMD . '"'
	"has window,wait,no hit-enter 
	elseif iMode==1
		let sEXE='silent !cmd /c "'
		let sEXE=sEXE . a:sCMD . '"'
	"has window,wait,hit-enter
	elseif iMode==2
		let sEXE='!cmd /c "'
		let sEXE=sEXE . a:sCMD . '"'
	"has window no wait,hit-enter
	elseif iMode==3
		let sEXE='silent !start cmd /c "'
		let sEXE=sEXE . a:sCMD . '&&pause"'
"	else
"		let sEXE='silent !start /b cmd /c "'
"		let sEXE=sEXE . a:sCMD . '"'
	endif
	execute(sEXE)
endfunction

function! SysInit()
	if !filereadable(g:g_SysEffqf)||g:OS#win
		let sCMD="fsutil file createnew " . g:g_SysEffqf . " 0" 
		call Execmd(sCMD)
	endif

	for sProPath in keys(g:g_ProPaths)
		let sPath=substitute(sProPath,':*'.g:g_PathSplit,"-",'g')
		let sPath=g:g_DataPath . g:g_PathSplit . sPath
		if g:OS#win
			let sCMD="md " . sPath
			call Execmd(sCMD)
		endif
		let g:g_Pro2DB[sProPath]=sPath
		let lstTmp=g:g_ProPaths[sProPath]
		let lstSub=lstTmp[0]
		let lstOth=lstTmp[1]
		let lstIgn=lstTmp[2]
		let lstExt=lstTmp[3]
		let g:g_ProExts[sProPath]=lstExt
		let g:g_ProPaths[sProPath]=[]
		let g:g_ProIgnores[sProPath]=lstIgn
        call add(g:g_ProPathList, sProPath)
        for sSub in lstSub 
			call add(g:g_ProPaths[sProPath],sProPath . sSub)
		endfor
		for sOth in lstOth
			call add(g:g_ProPaths[sProPath],sOth)
		endfor
	endfor
    call sort(g:g_ProPathList)
endfunction
call SysInit()

"名词设定
let g:Author="WangZhiyun"
"start_setting======================================================
set autochdir
set autoread
"set noimdisable		"离开输入模式后切换到英文输入法

"撤销文本缓存
set undofile
let g:g_UndoDir=g:g_DataPath.g:g_PathSplit.'undo'
execute("set undodir=".g:g_UndoDir)
if !isdirectory(g:g_UndoDir)
	call mkdir(g:g_UndoDir,"p")
endif
"maxinum bumber of changes that can be undone
set undolevels=1000

"config ui_begin***************************************
set number							"显示行号
set laststatus=2					"启用状态栏信息
set cmdheight=2						"设置命令行的高度为2，默认为1
set cursorline						"突出显示当前行
set nowrap							"设置不自动换行
set shortmess=atI					"去掉欢迎界面
set equalalways
set eadirection=
"help guioptions 滚动条、工具栏
set guioptions-=r
set guioptions-=L
set guioptions-=b
set guioptions-=T

"默认窗口位置和大小
if g:OS#gui
	if g:OS#win
		winpos 0 0
		"max window 
		au GUIEnter * simalt ~x
	elseif g:OS#mac||g:OS#unix
		winpos 0 0
		set lines=68 columns=210
	endif
endif

"efficient
set hidden

"encoding
set modifiable
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk
set termencoding=utf-8

"indent and fold 
set smartindent									   "启用智能对齐方式
"set noexpandtab										 "将空格转换为Tab键
set expandtab										 "将Tab键转换为空格
set tabstop=4										 "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4									  "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab										  "指定按一次backspace就删除shiftwidth宽度

"indent: 如果用了:set indent,:set ai 等自动缩进，想用退格键将字段缩进的删掉，必须设置这个选项。否则不响应。
"eol:如果插入模式下在行开头，想通过退格键合并两行，需要设置eol。
"start：要想删除此次插入前的输入，需设置这个。
set backspace=indent,eol,start

"fold
set foldenable										"启用折叠
"set foldmethod=syntax
"set foldmethod=manual
set foldmethod=indent								 "indent 折叠方式
set foldlevelstart=99
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

"search and replace
nnoremap cS :%s/\s\+$//g<CR>:noh<CR>				  "clear space end of line
"忽略大小写
"set ignorecase
"搜索时智能忽略大小写
"set smartcase

"set noincsearch
"在查找时输入字符过程中就高亮显示匹配点。然后回车跳到该匹配点。
set incsearch

"syntax
syntax on
set background=light
"搜索高亮
set hlsearch
if exists("g:g_MyColor")
	execute('colorscheme ' . g:g_MyColor)
end
let g:g_allschems=split(globpath($VIMRUNTIME .g:g_PathSplit. "colors","*"),'\n')
if exists("g:g_MyColorLib")
	let g:g_allschems+=split(globpath(g:g_MyColorLib,"*"),'\n')
end

set textwidth=500
" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

set errorformat+=%f:%l:%m
set sessionoptions=buffers,folds,tabpages,help
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:_
set fillchars=stl:\ ,stlnc:\ ,vert:\|,fold:-,diff:-
execute("set dictionary+=" . g:g_DataPath . g:g_PathSplit . "dict.txt")

"font
if exists("g:g_MyFont")
	execute('set guifont=' . g:g_MyFont . '|let &guifontwide=&guifont')
end


"keymap================================================================================

"导入变量
"python << EOF
"import cachesearch 
"from vimenv import env
"EOF

"start_func============================================================================================================
function! NewTabForTheFile()
	if !IsRealFile()
		echo "this file can't edit"
		return
	endif
	let sPath=expand("%:p")
	exec "tabnew\|call ClearTabBufs()\|call AutoLayoutByOs()"
	if bufwinnr(g:g_SysEffqf)!=#-1
		execute(bufwinnr(g:g_SysEffqf) . " wincmd w")
		execute("wincmd c")
	endif
	exec "e ".sPath
endfunction

function! ClearSuffixFiles(...)
	let sInputList=get(a:000,0,-1)
	echo sInputList
	"exec "!time bash /Users/wangzhiyun/work/sh/rm_suffixlist.sh"
endfunction

function! GetCommentSignHead()
	let dComment = {'cpp':'//','c':'//','h':'//','vim':'"','java':'//','lua':'--','sol':'//','js':'//','javascript':'//','typescript':'//', 'dosbatch':'::', 'html':'<!--', 'css':'/*', 'less':'/*'}
	let type = &filetype
	"默认值不要改否则其它用到的地方会出错
	return get(dComment, type, '#')
endfunction
function! GetCommentSignTail()
	let dComment={'html':'-->', 'css':'*/', 'less':'*/'}
	let type = &filetype
	"默认值不要改否则其它用到的地方会出错
	return get(dComment, type, '')
endfunction

"多行注释
function! CommentFunc(sLine,sRange)
	" 行尾
	let g:g_IgnoreHtmlTage += 1
	let sTail = GetCommentSignTail()
	let lenTail = len(sTail)
	if lenTail > 0
		let len = len(getline(a:sLine))
		if getline(a:sLine)[len-lenTail:]==#sTail
			execute(a:sRange . " normal " . "$" . (lenTail-1) . "X" . "x")
		else
			execute(a:sRange . " normal " . "$a" . sTail)
		endif
	endif

	" 行首
	let sHead=GetCommentSignHead()
	let lenHead=len(sHead)
	if getline(a:sLine)[0:lenHead-1]==#sHead
		execute(a:sRange . " normal " . "0" . lenHead . "x")
	else
		execute(a:sRange . " normal " . "0i" . sHead)
	endif
	let g:g_IgnoreHtmlTage -= 1
endfunction

function! AddSeparatorLine()
	if !IsRealFile()
		return
	endif
	execute("normal o".GetCommentSignHead()."--------------------------------------".GetCommentSignTail())
endfunction

function! GetEffectiveLine(sMsg)
	let l:sMsg=getline(a:sMsg)
python << EOF
from vimenv import env
sMsg=env.var("l:sMsg")
sSpaceList=[" ","　"]
sSpace=" "
for sStr in sSpaceList:
	if sStr==sMsg[0:len(sStr)]:
		sSpace=sStr
		break
iSpaceCnt=0
iSpaceLen=len(sSpace)
sLine=""
for i in xrange(0,len(sMsg)/iSpaceLen):
	sStr=sMsg[i*iSpaceLen:(i+1)*iSpaceLen]
	if sStr==sSpace:
		iSpaceCnt+=1
	else:
		sLine=sMsg[iSpaceCnt*iSpaceLen:]
		break
sPreLine=iSpaceCnt*sSpace
env.exe("let l:sPreLine=\"%s\""%sPreLine)
env.exe("let l:sLine=\"%s\""%sLine)
EOF
	return [l:sPreLine,l:sLine]
endfunction

"color scheme
function! ChangeScheme()
	let lstTmp=[]
	let lstTmp2=[]
	let iCnt=0
	for i in range(0,len(g:g_allschems)-1)
		let name=fnamemodify(g:g_allschems[i],":t:r")
		if fnamemodify(g:g_allschems[i],":e")!="vim"
			continue
		end
		let iCnt+=1
		call add(lstTmp, name."---->". iCnt)
		call add(lstTmp2,name)
	endfor
	"无输入时默认值是0,要避开这个值
	let iFile=inputlist(lstTmp)
	if iFile<1||iFile>len(lstTmp2)
		return
	end
	let sFile=get(lstTmp2,iFile-1,-1)
	if sFile==#-1
		return
	endif
	execute("colorscheme " . sFile)
endfunction

"文件头添加注释
autocmd BufNewFile *.py,*.java,*.lua,*.sh,*.c,*.cpp,*.h exec ":call SetTitle()"

function! WriteTitle(tInfo,lineno)
	let sComment=GetCommentSignHead()
	let iLine=a:lineno
	for sInfo in a:tInfo
		call setline(iLine,sComment.sInfo)
		let iLine+=1
	endfor
	call append(iLine,"")
endfunction

function! SetTitle()
	let fType=expand("%:e")
	let tInfo=[]
	let iStartLine=1
	if fType=="py"
		call add(tInfo," -*- coding: utf-8 -*-")
	elseif fType=="sh"
		call add(tInfo,"!/bin/sh")
	elseif fType=="bash"
		call add(tInfo,"!/bin/bash")
	endif
	call add(tInfo,"===================================")
	call add(tInfo," Author	:".g:Author)
	call add(tInfo," Create	:".strftime("%Y-%m-%d %H:%M:%S"))
	call add(tInfo,"===================================")
	call WriteTitle(tInfo,iStartLine)
endfunction

function! AddModifyTime()
	let sComment=GetCommentSignHead()
	let iCurLine=line(".")
	if iCurLine>0
		let iCurLine=iCurLine-1
	else
		let iCurLine=iCurLine
	endif
	let sTime=sComment." Modify(wzy):".strftime("%Y-%m-%d %H:%M:%S")
	call append(iCurLine,sTime)
	"let sAuthor="\# Author	:".g:Author
	"call append(iCurLine+1,sAuthor)
	execute("w!")
endfunction

"网上看来的
function! CompileAndRun()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time sh %
	elseif &filetype == 'python'
		exec "!time python3 %"
	elseif &filetype == 'html'
		exec "!firefox % &"
	elseif &filetype == 'go'
		"exec "!go build %<"
		exec "!time go run %"
	elseif &filetype == 'mkd'
		exec "!~/.vim/markdown.pl % > %.html &"
		exec "!firefox %.html &"
	elseif &filetype == 'lua'
		exec "!time lua %"
	elseif &filetype == 'sql'
		exec "!mysql -u root -p123456 < %"
	elseif &filetype == 'javascript'
		exec '!node %'
	endif
endfunction

function! F5Func()
	if expand("%:e")==#"py"
		call Execmd("python " . expand("%") . " 2>>" . g:g_SysEffqf,3)
	else
		call Execmd(expand("%:r") . ".exe" . " 2>>" . g:g_SysEffqf,3)
	endif
endfunction


" -----------------------------------------------------------------------------
"  < 编译、连接、运行配置 (目前只配置了C、C++、Java语言)>
" -----------------------------------------------------------------------------
" F9 一键保存、编译、连接存并运行
"nmap <F9> :call Run()<CR>
"imap <F9> <ESC>:call Run()<CR>

" Ctrl + F9 一键保存并编译
"nmap <c-F9> :call Compile()<CR>
"imap <c-F9> <ESC>:call Compile()<CR>

" Ctrl + F10 一键保存并连接
"nmap <c-F10> :call Link()<CR>
"imap <c-F10> <ESC>:call Link()<CR>

let s:LastShellReturn_C = 0
let s:LastShellReturn_L = 0
let s:ShowWarning = 1
let s:Obj_Extension = '.o'
let s:Exe_Extension = '.exe'
let s:Class_Extension = '.class'
let s:Sou_Error = 0

let s:windows_CFlags = 'gcc\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

let s:windows_CPPFlags = 'g++\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CPPFlags = 'g++\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

let s:JavaFlags = 'javac\ %'

func! Compile()
	exe ":ccl"
	exe ":update"
	let s:Sou_Error = 0
	let s:LastShellReturn_C = 0
	let Sou = expand("%:p")
	let v:statusmsg = ''
	if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
		let Obj = expand("%:p:r").s:Obj_Extension
		let Obj_Name = expand("%:p:t:r").s:Obj_Extension
		if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
			redraw!
			if expand("%:e") == "c"
				if g:OS#win
					exe ":setlocal makeprg=".s:windows_CFlags
				else
					exe ":setlocal makeprg=".s:linux_CFlags
				endif
				echohl WarningMsg | echo " compiling..."
				silent make
			elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
				if g:OS#win
					exe ":setlocal makeprg=".s:windows_CPPFlags
				else
					exe ":setlocal makeprg=".s:linux_CPPFlags
				endif
				echohl WarningMsg | echo " compiling..."
				silent make
			endif
			redraw!
			if v:shell_error != 0
				let s:LastShellReturn_C = v:shell_error
			endif
			if g:OS#win
				if s:LastShellReturn_C != 0
					exe ":bo cope"
					echohl WarningMsg | echo " compilation failed"
				else
					if s:ShowWarning
						exe ":bo cw"
					endif
					echohl WarningMsg | echo " compilation successful"
				endif
			else
				if empty(v:statusmsg)
					echohl WarningMsg | echo " compilation successful"
				else
					exe ":bo cope"
				endif
			endif
		else
			echohl WarningMsg | echo ""Obj_Name"is up to date"
		endif
	elseif expand("%:e") == "java"
		let class = expand("%:p:r").s:Class_Extension
		let class_Name = expand("%:p:t:r").s:Class_Extension
		if !filereadable(class) || (filereadable(class) && (getftime(class) < getftime(Sou)))
			redraw!
			exe ":setlocal makeprg=".s:JavaFlags
			echohl WarningMsg | echo " compiling..."
			silent make
			redraw!
			if v:shell_error != 0
				let s:LastShellReturn_C = v:shell_error
			endif
			if g:OS#win
				if s:LastShellReturn_C != 0
					exe ":bo cope"
					echohl WarningMsg | echo " compilation failed"
				else
					if s:ShowWarning
						exe ":bo cw"
					endif
					echohl WarningMsg | echo " compilation successful"
				endif
			else
				if empty(v:statusmsg)
					echohl WarningMsg | echo " compilation successful"
				else
					exe ":bo cope"
				endif
			endif
		else
			echohl WarningMsg | echo ""class_Name"is up to date"
		endif
	else
		let s:Sou_Error = 1
		echohl WarningMsg | echo " please choose the correct source file"
	endif
	exe ":setlocal makeprg=make"
endfunc

func! Link()
	call Compile()
	if s:Sou_Error || s:LastShellReturn_C != 0
		return
	endif
	if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
		let s:LastShellReturn_L = 0
		let Sou = expand("%:p")
		let Obj = expand("%:p:r").s:Obj_Extension
		if g:OS#win
			let Exe = expand("%:p:r").s:Exe_Extension
			let Exe_Name = expand("%:p:t:r").s:Exe_Extension
		else
			let Exe = expand("%:p:r")
			let Exe_Name = expand("%:p:t:r")
		endif
		let v:statusmsg = ''
		if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
			redraw!
			if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
				if expand("%:e") == "c"
					setlocal makeprg=gcc\ -o\ %<\ %<.o
					echohl WarningMsg | echo " linking..."
					silent make
				elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
					setlocal makeprg=g++\ -o\ %<\ %<.o
					echohl WarningMsg | echo " linking..."
					silent make
				endif
				redraw!
				if v:shell_error != 0
					let s:LastShellReturn_L = v:shell_error
				endif
				if g:OS#win
					if s:LastShellReturn_L != 0
						exe ":bo cope"
						echohl WarningMsg | echo " linking failed"
					else
						if s:ShowWarning
							exe ":bo cw"
						endif
						echohl WarningMsg | echo " linking successful"
					endif
				else
					if empty(v:statusmsg)
						echohl WarningMsg | echo " linking successful"
					else
						exe ":bo cope"
					endif
				endif
			else
				echohl WarningMsg | echo ""Exe_Name"is up to date"
			endif
		endif
		setlocal makeprg=make
	elseif expand("%:e") == "java"
		return
	endif
endfunc

func! Run()
	let s:ShowWarning = 0
	call Link()
	let s:ShowWarning = 1
	if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
		return
	endif
	let Sou = expand("%:p")
	if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
		let Obj = expand("%:p:r").s:Obj_Extension
		if g:OS#win
			let Exe = expand("%:p:r").s:Exe_Extension
		else
			let Exe = expand("%:p:r")
		endif
		if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
			redraw!
			echohl WarningMsg | echo " running..."
			if g:OS#win
				exe ":!%<.exe"
			else
				if g:OS#gui
					exe ":!gnome-terminal -x bash -c './%<; echo; echo 请按 Enter 键继续; read'"
				else
					exe ":!clear; ./%<"
				endif
			endif
			redraw!
			echohl WarningMsg | echo " running finish"
		endif
	elseif expand("%:e") == "java"
		let class = expand("%:p:r").s:Class_Extension
		if getftime(class) >= getftime(Sou)
			redraw!
			echohl WarningMsg | echo " running..."
			if g:OS#win
				exe ":!java %<"
			else
				if g:OS#gui
					exe ":!gnome-terminal -x bash -c 'java %<; echo; echo 请按 Enter 键继续; read'"
				else
					exe ":!clear; java %<"
				endif
			endif
			redraw!
			echohl WarningMsg | echo " running finish"
		endif
	endif
endfunc

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
	if g:OS#win
		let sCMD=$VIMRUNTIME . "\\Recycle.exe " . sPath
		call Execmd(sCMD)
	else
		exec "silent !rm ".sPath
	endif
	let iBNum=bufnr("%")
	execute(iBNum . "bd")
endfunction

"command
command! -nargs=?  Goto call Goto(<f-args>) 
function! Goto(...)
	let sFile=get(a:000,0,-1)
	if sFile==#-1 
		let lstTmp=[]
		for i in range(0,len(g:g_GotoFiles)-1)
			call add(lstTmp,i . ' :' . g:g_GotoFiles[i])
		endfor
		let sFile=inputlist(lstTmp)
	endif
	let sFile=get(g:g_GotoFiles,sFile,-1)
	if sFile==#-1
		return
	endif
	execute("e " . sFile)
endfunction

command! -nargs=?  GTree call GotoTree(<f-args>) 
function! GotoTree(...)
	let sFile=get(a:000,0,-1)
"	let lstPath=keys(g:g_ProPaths)
	let lstPath=g:g_ProPathList
	if sFile==#-1 
		let lstTmp=[]
		for i in range(0,len(lstPath)-1)
			call add(lstTmp,i."->".lstPath[i])
		endfor
		let sFile=inputlist(lstTmp)
	endif
	let sFile=get(lstPath,sFile,-1)
	if sFile==#-1
		return
	endif
	execute("NERDTree " . sFile)
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

function! MyTextFormat()
	"test
	"let lstBothOP=[""]
	let lstBothOP=["=","\\/","\\*","+",")","(","\\^","!","\\-","<",">",","]
	let lstRigthOP=[]
	let lstLeftOP=[]
	let sRight=" \\+"
	let sLeft=" \\+"
	let sComment=GetCommentSign()
	let iStartLine=2
	if &filetype=="lua"
		let iStartLine=1
	end
	for sSign in lstBothOP+lstRigthOP
		let sExe=iStartLine.",$s/".sSign.sRight."/".sSign."/g"
		execute(sExe)
		echom sExe
	endfor
	for sSign in lstBothOP+lstLeftOP
		let sExe=iStartLine.",$s/".sLeft.sSign."/".sSign."/g"
		execute(sExe)
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
	silent exec "set fileencoding=utf-8"
	let iCurLine=line(".")
	if (&filetype=="py"||&filetype=="python")&&(iCurLine!=0&&g:startinsertline!=0)
		let sExe='Autopep8 --range '.g:startinsertline.' '.iCurLine
		execute(sExe)
	endif
	silent exec "set fileencoding=utf-8"
endfunction

"function! AutoPEP8()
"	silent exec "set fileencoding=utf-8"
"	silent w
"	call Autopep8()
"	silent exec "set fileencoding=utf-8"
"	silent w
"endfunction

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

function! CurFileInBundle()
	if InSysBuf()
		return 0
	endif
	let sPath=expand("%:p")
	let sPathList=split(sPath,g:g_PathSplit)
	for sName in sPathList
		if sName=="bundle"
			return 1
		endif
	endfor
	return 0
endfunction

function! IsRealFile()
	if InSysBuf()
		return 0
	endif
	for sType in ["text","python","vim","c","cpp","h","java","lua","sh","solidity","javascript","typescript","html","css", "dosbatch"]
		if sType==&filetype
			return 1
		endif
	endfor
	return 0
endfunction

function! IsOldJS()
	let l:fType=expand("%:e")
	if fType!="js"
		return 0
	endif
python << EOF
from vimenv import env
path = env.var('expand("%:p:h")')
OldList = env.var('g:g_JS_expandtab')
env.exe("let l:ret=0")
for name in OldList:
	if "assets" in path and name in path:
		env.exe("let l:ret=1")
		break
EOF
	return l:ret
endfunction

function! FileSetChange()
	if IsRealFile()
		if &filetype=="text"
			silent execute("set wrap")
			"silent execute("set noimd")
		else
			silent execute("set nowrap")
			"silent execute("set imd")
		endif
		"silent execute("set tabstop=4")
		"silent execute("set shiftwidth=4")
		"if &filetype=="python" || &filetype=="solidity" || IsOldJS()
		"	silent execute("set expandtab")
		"	"silent execute("%retab!")
		"	"silent execute("w!")
		"else
		"	silent execute("set noexpandtab")
		"endif
	endif
endfunction

function! FileMapChange()
	if IsRealFile()
		if &filetype=="python"
			nnoremap <Leader>ad oprint("wzytxt======")<left><left>
			nnoremap <Leader>dd :g/^.*print("wzytxt=.*$/d<CR>
		elseif &filetype=="lua"
			nnoremap <Leader>ad oprint("wzytxt======")<left><left>
			nnoremap <Leader>dd :g/^.*print("wzytxt=.*$/d<CR>
			nnoremap <Leader>at oprint("wzytxt==\n",debug.traceback())<ESC>
		elseif &filetype=="java"
			nnoremap <Leader>ad oSystem.out.println("wzytxt======");<left><left><left>
			nnoremap <Leader>dd :g/^.*println("wzytxt=.*$/d<CR>
		elseif &filetype=="c"||&filetype=="cpp"
			nnoremap <Leader>ad oprintf("wzytxt======\n");<left><left><left><left><left>
			nnoremap <Leader>dd :g/^.*printf("wzytxt=.*$/d<CR>
		elseif &filetype=="javascript"||&filetype=="typescript"
			nnoremap <Leader>ad oconsole.log("wzytxt======");<left><left><left>
			nnoremap <Leader>dd :g/^.*console.*("wzytxt=.*$/d<CR>
			nnoremap <Leader>at oconsole.warn("wzytxt======");<ESC>
		elseif &filetype=="dosbatch"
			nnoremap <Leader>ad oecho "wzytxt======"<left>
			nnoremap <Leader>dd :g/^.*echo.*wzytxt=.*$/d<CR>
		endif
		if &filetype=="text"
			inoremap （ （）<left>
			inoremap 《 《》<left>
			inoremap “ “”<left>
			inoremap ” “”<left>
			inoremap 【 【】<left>
			inoremap ’ ‘’<left>
			inoremap ‘ ‘’<left>
		endif
		if &filetype=="html"
			"inoremap > <ESC>:call InsertHtmlTag()<CR>a<CR><Esc>O
			inoremap > <ESC>:call InsertHtmlTag()<CR>a
		else
			inoremap > >
		endif
	endif
	if !InSysBuf()
		if g:OS#mac
			nnoremap <D-w> :wq!<CR>
			vnoremap <D-w> :wq!<CR>
		elseif g:OS#win
			nnoremap <A-w> :wq!<CR>
			vnoremap <A-w> :wq!<CR>
		endif
	else
		if g:OS#mac
			nnoremap <D-w> :w<CR>
			vnoremap <D-w> :w<CR>
		elseif g:OS#win
			nnoremap <A-w> :w<CR>
			vnoremap <A-w> :w<CR>
		endif
	endif
endfunction

function! OpenAllVimSetting()
	execute("e ".$VIMFILE)
	execute("vs ".$MYSETTING)
endfunction

function! GotoWindow(sWin)
	for iBuf in tabpagebuflist() 
		if bufname(iBuf)!~#a:sWin
			continue
		endif
		let iWin=bufwinnr(iBuf)
		execute(iWin . " wincmd w")
		return
	endfor
endfunction


"启动时打开上次离开时的内容

function! BuildTag(...)
	let iMode=get(a:000,0,0)
	if g:g_CurPro==#""
		return
	endif
	let sCMD='del ' . g:g_TagPath . '&&ctags -R -f '
	let sCMD=sCMD . ' ' . g:g_TagPath 
	for sSub in g:g_ProPaths[g:g_CurPro]
		let sCMD=sCMD . ' ' . sSub
	endfor
	"win下ctags占用太多cpu，又太多进程；mac下Execmd不能用。先屏蔽ctags
	return
	call Execmd(sCMD,iMode)
endfunction

function! BuildCS(...)
	if g:g_UseCS!=#1
		return
	endif
	let iMode=get(a:000,0,0)
	if g:g_CurPro==#""
		return
	endif
	for sSub in g:g_ProPaths[g:g_CurPro]
		if sSub==#g:g_ProPaths[g:g_CurPro][0]
			let sCMD='dir /b /s ' . sSub . '\*.py>' . g:g_CSFiles
		else
			let sCMD= sCMD . '&&dir /b /s ' . sSub . '\*.py>>' . g:g_CSFiles
		endif
	endfor
		let sCMD= sCMD . '&&cd /d ' . g:g_CurDB . '&&cscope -Rb'
	call Execmd(sCMD,iMode)
endfunction

function! ChangePro(sNewPro)
	let g:g_CurPro=a:sNewPro
	let g:g_CurDB=g:g_Pro2DB[g:g_CurPro]
	let g:g_TagPath=g:g_CurDB .g:g_PathSplit. 'systag'
	let g:g_CSOut=g:g_CurDB .g:g_PathSplit. 'cscope.out'
	let g:g_CSFiles=g:g_CurDB .g:g_PathSplit. 'cscope.files'

	if !filereadable(g:g_TagPath)
		call BuildTag(1)
	endif
	"execute("set tags=" . g:g_TagPath)

	if g:g_UseCS==#1
		if !filereadable(g:g_CSOut)
			call BuildCS(1)
		silent! cscope kill -1
		execute("cs add " . g:g_CSOut)
		endif
	endif

	call OnChangePro(a:sNewPro)
endfunction

function! OnChangePro(sPro)
	if !has_key(g:g_ProPaths,a:sPro)
		return
	endif

	let g:pymode_lint_options_pylint={}
	let dOpt=g:pymode_lint_options_pylint
	let sAllPath=""
	for lstTmp in values(g:g_ProPaths)
		for sTmp in lstTmp
			let sAllPath=sAllPath . ",\"" . sTmp . "\"" 
		endfor
	endfor
	if len(sAllPath)!=#0 
		let sAllPath=sAllPath[1:]
	endif

	let sCurPath="" 
	for sTmp in g:g_ProPaths[a:sPro]
		let sCurPath=sCurPath . ",\"" . sTmp . "\""
	endfor
	if len(sCurPath)!=#0 
		let sCurPath=sCurPath[1:]
	endif

	let sInitHook='import sys'
	let sInitHook=sInitHook . ';setT=set(sys.path)-set([' . sAllPath . '])'
	let sInitHook=sInitHook . ';setT=setT.union(set([' . sCurPath . ']))'
	let sInitHook=sInitHook . ';sys.path=list(set(setT));'
	let dOpt['init-hook']=sInitHook
	let dOpt['additional-builtins']=g:g_Builtins
endfunction

function! FrontBufHis()
	if g:g_BufHisIdx>=#-1
		echo "front of his"
		return
	endif
	let g:g_BufHisIdx+=1
	let sHis=g:g_BufHis[g:g_BufHisIdx]
	let g:g_InBufHis=1
	execute("b " . sHis)
	echom "" . g:g_BufHisIdx . len(g:g_BufHis)
endfunction

function! BackBufHis()
	if g:g_BufHisIdx<=#-len(g:g_BufHis)
		echo "back of his"
		return
	endif
	let g:g_BufHisIdx-=1
	let sHis=g:g_BufHis[g:g_BufHisIdx]
	let g:g_InBufHis=1
	execute("b " . sHis)
	echom "" . g:g_BufHisIdx . len(g:g_BufHis)
endfunction

function! GotoBuf(sBuf)
	let iWinNum = bufwinnr(a:sBuf)
	if iWinNum==#-1
		execute("b " . a:sBuf)
	else
		execute(iWinNum . " wincmd w")
	endif
endfunction

"tool
function! BufModifiable(iBuf)
	if getbufvar(a:iBuf,"&modifiable")!=#1
		return 0
	endif
	if InSysBuf(a:iBuf)
		return 0
	endif
	return 1
endfunction

function! InSysBuf(...)
	let iBuf=get(a:000,0,0)
	if iBuf==#0
		let iBuf=bufnr("%")
	endif
	for sBuff in g:g_FixBuff
		if bufname(iBuf)=~#sBuff
			return 1
			break
		endif
	endfor
	return 0 
endfunction

function! OnChangeDir()
	if InSysBuf()
		return
	endif
	call FileSetChange()
	call FileMapChange()
	let sNewPath=expand("%:p")
	"bufhis
	if (len(g:g_BufHis)==#0 || g:g_BufHis[-1]!=#sNewPath) && g:g_InBufHis==#0
		call add(g:g_BufHis,sNewPath)
		if len(g:g_BufHis)>#50
			call remove(g:g_BufHis,0)
		endif
	endif
	if !g:g_InBufHis
		let g:g_BufHisIdx=-1
	endif
	let g:g_InBufHis=0
	"pro
	let sNewPath=expand("%:p:h")
	let sNewPro=""
	for sPro in reverse(sort(keys(g:g_ProPaths)))
		if stridx(sNewPath,sPro)==-1
			continue
		endif
		let sNewPro=sPro
		break
	endfor
	if sNewPro==#g:g_CurPro
		return
	endif
	if sNewPro==#""
		return
	endif
	if g:OS#win||g:OS#mac||g:OS#unix
		call ChangePro(sNewPro)
	endif
endfunction

function! BeforeLeave()
	call KillSearch()
	call CloseLayout()
	call SaveSearch()
	call SaveBufMgr()
	if g:OS#win||g:OS#mac||g:OS#unix
		execute('mksession! ' . g:g_MFSession)
		let lstLine=readfile(g:g_MFSession)
		let lstNew=[]
		for sLine in lstLine
			call add(lstNew,sLine)
			if stridx(sLine,"edit")==-1
				continue
			endif
			call add(lstNew,"filetype detect")
		endfor
		call writefile(lstNew,g:g_MFSession)
	endif
endfunction

function! AfterEnter()
	if g:OS#win||g:OS#mac||g:OS#unix
		execute('source ' . g:g_MFSession)
	endif
	call EnterOpen()
	call CreateBufMgr()
	call AftAuGroup()
endfunction

function! EnterOpen()
	let iCurTab=tabpagenr()
	for iTab in range(1,tabpagenr('$'))
		tabn
		call AutoLayoutByOs()
	endfor
	execute("tabn " . iCurTab)
endfunction

function! BasicLayout()
	call CloseLayout()
	MBEOpen
	"bo 10 copen 
	"execute("vs|e " . g:g_SysEffqf . "|filetype detect")
	call NewSysEffqf()
	NERDTree
	TlistToggle
	silent execute("set equalalways")
endfunction

function! ZeroBasicLayout()
	call CloseLayout()
	MBEOpen
	call NewSysEffqf()
	NERDTree
	silent execute("set equalalways")
endfunction

function! AutoLayoutByOs()
	if g:OS#win
		call BasicLayout()
	else
		call ZeroBasicLayout()
	endif
endfunction

function! NewSysEffqf()
	execute("bo new " . g:g_SysEffqf . "|resize 5|set winfixheight|filetype detect")
endfunction

function! CloseLayout()
	silent TlistClose	
	MBEClose
"	cclose
	if bufwinnr(g:g_SysEffqf)!=#-1
		execute(bufwinnr(g:g_SysEffqf) . " wincmd w")
		execute("wincmd c")
	endif
	NERDTreeClose
endfunction

function! DetAllFile()
	let iCurTab=tabpagenr()
	for iTab in range(1,tabpagenr('$'))
		execute("tabn " . iTab)
		for iWin in range(1,tabpagewinnr(iTab,'$'))
			execute(iWin . "wincmd w")
			execute("filetype detect")
		endfor
	endfor
	execute("tabn " . iCurTab)
endfunction

function! QfMakeConv()
	let qflist = getqflist()
	for i in qflist
		let i.text = iconv(i.text, "gbk", "utf-8")
	endfor
	call setqflist(qflist)
endfunction

function! SysOnWinEnter()
	for name in ['__Tag_List__', 'NERD_tree', 'MiniBufExplorer']
		if bufname(winbufnr(winnr()))=~name || bufname(winbufnr(winnr('#')))=~name
			return
		endif
	endfor
	let g:g_LastWinr=winnr('#')
endfunction

function! BigFile(sFile)
	if getfsize(a:sFile)>#1024*200
		filetype off
	else
		filetype on
	endif
endfunction


"初始化的时候就定义，OnchangeDir里总是上个文件的路径
function! AftAuGroup()
	 augroup aftgroup
		autocmd!
		autocmd BufEnter * call OnChangeDir() 
		"autocmd BufRead,BufNewFile,BufEnter * call OnChangeDir() 
	augroup END
endfunction

function! InitAuGroup()
	augroup inigroup
		autocmd!
		autocmd VimLeave * call BeforeLeave() 
		autocmd VimEnter * call AfterEnter() 
		"t_vb must set here
		autocmd GUIEnter * set vb t_vb=
		autocmd QuickfixCmdPost make call QfMakeConv()
		autocmd BufWritePost * call BuildTag()	
		autocmd BufWritePost * call BuildCS()  
		autocmd WinEnter * call SysOnWinEnter()  
		autocmd BufReadPre * call BigFile(expand("<afile>"))  
	augroup END
endfunction
call InitAuGroup()

"html自动补全
autocmd BufNewFile *.html setlocal filetype=html
let g:g_IgnoreHtmlTage = 0
function! InsertHtmlTag()
	let pat = '\c<\w\+\s*\(\s\+\w\+\s*=\s*[''#$;,()."a-z0-9]\+\)*\s*>'
	normal! a>
	if g:g_IgnoreHtmlTage
		return
	endif
	let save_cursor = getpos('.')
	let result = matchstr(getline(save_cursor[1]), pat)
	"if (search(pat, 'b', save_cursor[1]) && searchpair('<','','>','bn',0,  getline('.')) > 0)
	if (search(pat, 'b', save_cursor[1]))
		normal! lyiwf>
		normal! a</
		normal! p
		normal! a>
	endif
	:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
endfunction
"inoremap > <ESC>:call InsertHtmlTag()<CR>a<CR><Esc>O

"start_keymap================================================================================

if g:OS#win
	nnoremap <F5> :call F5Func()<CR>
	nnoremap <F12> :!start explorer /select, %:p<CR>
	nnoremap <Leader><Leader>d :call DelCurFile()<CR>
	nnoremap <A-w> :q<CR>
	vnoremap <A-w> :q<CR>
else
	nnoremap <F5> :call CompileAndRun()<CR>
	nnoremap <c-s> :w!<CR>
	vnoremap <c-s> :w!<CR>
	nnoremap <D-r> <c-r>
endif

nnoremap <Leader><Leader>d :call DelCurFile()<CR>
nnoremap <F7> :NERDTreeToggle<CR>
inoremap <F7> <ESC>:NERDTreeToggle<CR>
nnoremap <F8> :call NewTabForTheFile()<CR>
nnoremap <F11> :NERDTreeFind<CR>
inoremap <F11> <ESC>:NERDTreeFind<CR>

nnoremap <c-up> :call BackBufHis()<CR>
nnoremap <c-down> :call FrontBufHis()<CR>
vnoremap \\ :<c-w>call CommentFunc("'<","'<,'>-1")<CR>
noremap \\ :call CommentFunc(".","")<CR>

nnoremap <Leader><Leader>n :call RenameCurFile("<C-R>=expand("%:t")<CR>")<Left><Left>
nnoremap <Leader><Leader>c :call CheckPy()<CR>
nnoremap <F9> :call Run()<CR>
inoremap <F9> <ESC>:call Run()<CR>

"布局
nnoremap <F1> <SPACE> 
inoremap <F1> <SPACE> 
nnoremap <F2> :call OnlyTabBuff()<CR> 
nnoremap <F3> :tabnew\|call ClearTabBufs()\|call AutoLayoutByOs()\|execute("NERDTree " . g:g_DefaultTree)<CR>
nnoremap <F4> :call CloseLayout()\|tabc\|call ClearNoUseBuff()<CR>
nnoremap <F10> :tabedit <C-R>=expand("%:t")<CR><CR>
"nnoremap <Leader>lo :call BasicLayout()<CR>
nnoremap <Leader>lo :call AutoLayoutByOs()<CR>

"改变配色
nnoremap <Leader>cc :call ChangeScheme()<CR>

"文件
nnoremap <Leader>ov :e $VIMFILE<CR>
nnoremap <Leader>op :e $VIM/userdata/pros<CR>
nnoremap <Leader>om :e $MYSETTING<CR>
nnoremap <Leader>oa :call OpenAllVimSetting()<CR>
nnoremap <Leader>ua :source $VIMFILE\|source $MYSETTING\|call AutoLayoutByOs()<CR>
nnoremap <Leader>ec :execute("vsplit " . $VIMFOLDER.'\colors\health.vim')<CR> 
nnoremap <Leader>em :messages<CR>
nnoremap <Leader>es :execute("vsplit " . $VIM . '\vimfiles\UltiSnips\all.snippets')<CR>

"输入
nnoremap <Leader>t :call AddModifyTime()<CR>
nnoremap <Leader><Leader>a :call AntiPEP8()<CR>
nnoremap rr :%s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>/gc<Left><Left><Left>

"map
nnoremap <Leader>ss :execute("w\|source " . expand("%:p"))<CR> "保存加载当前文件

nnoremap L $
nnoremap H ^
vnoremap L $
vnoremap H ^

nnoremap <A-Right> :vertical res +1\|set winfixwidth<CR>
nnoremap <A-Left> :vertical res -1\|set winfixwidth<CR> 
nnoremap <A-Up> :res -1\|set winfixheight<CR>
nnoremap <A-Down> :res +1\|set winfixheight<CR>

nnoremap <Leader>y ^vg_"*y 
nnoremap <Leader>w viw"*y
vnoremap <Leader>y "*y
nnoremap <Leader><Leader>y ^vg_"*y:stop<CR> 
vnoremap <Leader><Leader>y "*y:stop<CR>

nnoremap <c-k> <c-w>k
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

if g:OS#mac
	nmap <D-1> :tabn 1<CR>:set equalalways<CR>
	nmap <D-2> :tabn 2<CR>:set equalalways<CR>
	nmap <D-3> :tabn 3<CR>:set equalalways<CR>
	nmap <D-4> :tabn 4<CR>:set equalalways<CR>
	nmap <D-5> :tabn 5<CR>:set equalalways<CR>
	nmap <D-6> :tabn 6<CR>:set equalalways<CR>
	nmap <D-7> :tabn 7<CR>:set equalalways<CR>
	nmap <D-8> :tabn 8<CR>:set equalalways<CR>
	nmap <D-9> :tabn 9<CR>:set equalalways<CR>
	nmap <D-left> <c-pageup>:set equalalways<CR>
	nmap <D-right> <c-pagedown>:set equalalways<CR>
else
	nmap <a-1> :tabn 1<CR>:set equalalways<CR>
	nmap <a-2> :tabn 2<CR>:set equalalways<CR>
	nmap <a-3> :tabn 3<CR>:set equalalways<CR>
	nmap <a-4> :tabn 4<CR>:set equalalways<CR>
	nmap <a-5> :tabn 5<CR>:set equalalways<CR>
	nmap <a-6> :tabn 6<CR>:set equalalways<CR>
	nmap <a-7> :tabn 7<CR>:set equalalways<CR>
	nmap <a-8> :tabn 8<CR>:set equalalways<CR>
	nmap <a-9> :tabn 9<CR>:set equalalways<CR>
"	nmap <c-s-left> <c-pageup>:set equalalways<CR>
"	nmap <c-s-right> <c-pagedown>:set equalalways<CR>
endif

inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

"use imap do not need type cr when complete 
imap <c-k> <Up>
imap <c-j> <Down>
imap <c-h> <Left>
imap <c-l> <Right>

"map
nnoremap tl :TlistClose<CR>:TlistToggle<CR>
nnoremap tlc :TlistClose<CR>
nnoremap <Leader>s :call AddSeparatorLine()<CR>

"goto
nnoremap <Leader>gq :call GotoWindow("sys.effqf")<CR> 
nnoremap <Leader>gt :call GotoWindow("NERD_tree")<CR> 
nnoremap <Leader>gm :call GotoWindow("-MiniBufExplorer-")<CR> 
nnoremap <Leader>gl :call GotoWindow("__Tag_List__")<CR> 
nnoremap <Leader>ge :call GotoEffqfLine()<CR>
nnoremap <Leader>p :wincmd }<CR>
nnoremap <Leader>cp :pclose<CR>
set previewheight=2


