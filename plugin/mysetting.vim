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
    let $VIMFOLDER = $VIM.'\vimfiles'
    let $BUNDLE = $VIMFOLDER.'\bundle'
	let $VIMFILE = $VIM.'\_vimrc'
    let $MYSETTING= $BUNDLE.'\mysetting\plugin\mysetting.vim'
	let $WORK = 'D:\work\server'
    let g:g_PathSplit="\\"
else
    let $VIMFOLDER = $HOME.'/.vim'
    let $BUNDLE = $VIMFOLDER.'/bundle'
	let $VIMFILE = $VIM.'/vimrc'
    let $MYSETTING= $BUNDLE.'/mysetting/plugin/mysetting.vim'
    let g:g_PathSplit="/"
    if g:OS#mac
	    let $GVIMFILE = $VIM.'/gvimrc'
        let $WORK = $HOME.'work/server'
    endif
endif

"============================================================================================================
let mapleader = "-"
let g:g_DataPath=$VIM . "/userdata"
let g:g_FixBuff=['sys.effqf','NERD_tree','-MiniBufExplorer-','__Tag_List__']
let g:g_LastWinr=-1
let g:g_BufHis=[]
let g:g_BufHisIdx=-1
let g:g_InBufHis=0

let g:g_MFSession=g:g_DataPath . '/mysession.vim'
let g:g_EffqfName="sys.effqf"
let g:g_SysEffqf=g:g_DataPath . '/' . g:g_EffqfName
let g:g_ProPaths={}
let g:g_ProExts={}
let g:g_CurPro=""
let g:g_Pro2DB={}
let g:g_UseCS=0
let g:SuperTabDefaultCompletionType="context"

function! ReadPros()
	let sEval="" 
	let sGval=""
	for sLine in readfile(g:g_DataPath . '/pros')
		let sLine=iconv(sLine,"gbk","utf-8")
		if len(sLine)==#0
			continue
		endif
		if sLine[0]==#'&'
			if len(sGval)!=#0
		"		let sEval=iconv(sEval,"gbk","utf-8")
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
		let lstExt=lstTmp[2]
		let g:g_ProExts[sProPath]=lstExt
		let g:g_ProPaths[sProPath]=[]
		for sSub in lstSub 
			call add(g:g_ProPaths[sProPath],sProPath . sSub)
		endfor
		for sOth in lstOth
			call add(g:g_ProPaths[sProPath],sOth)
		endfor
	endfor
endfunction
call SysInit()

"名词设定
let g:Author="WangZhiyun"
"setting======================================================
set autochdir
set autoread

"config ui_begin***************************************
set number							"显示行号
set laststatus=2				    "启用状态栏信息
set cmdheight=2					    "设置命令行的高度为2，默认为1
set cursorline						"突出显示当前行
set nowrap							"设置不自动换行
set shortmess=atI					"去掉欢迎界面
set equalalways
set eadirection=

"encoding
set encoding=utf-8
set fileencoding=gbk
"set fileencoding=utf-8
set fileencodings=utf-8,gbk
"set termencoding=utf8

"indent and fold 
set smartindent									   "启用智能对齐方式
"set noexpandtab										 "将Tab键转换为空格
set expandtab										 "将Tab键转换为空格
set tabstop=4										 "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4									  "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab										  "指定按一次backspace就删除shiftwidth宽度

"fold
set foldenable                                        "启用折叠
"set foldmethod=manual                                 "indent 折叠方式
set foldmethod=indent                                 "indent 折叠方式
set foldlevelstart=99
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

"search and replace
nnoremap cS :%s/\s\+$//g<CR>:noh<CR>                  "clear space end of line
set ignorecase
set smartcase
"set noincsearch

"syntax
syntax on
set background=light
"搜索高亮
set hlsearch
execute('colorscheme ' . g:g_MyColor)
let g:g_allschems=split(globpath($VIMRUNTIME . "/colors","*"),'\n')

set textwidth=500
" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

"导入变量
"python << EOF
"import cachesearch 
"from vimenv import env
"EOF

"func============================================================================================================

"color scheme
function! ChangeScheme()
	let lstTmp=[]
	let lstTmp2=[]
	for i in range(0,len(g:g_allschems)-1)
		call add(lstTmp,fnamemodify(g:g_allschems[i],":t:r") . "---->" . i)
		call add(lstTmp2,fnamemodify(g:g_allschems[i],":t:r"))
	endfor
	let iFile=inputlist(lstTmp)
	let sFile=get(lstTmp2,iFile,-1)
	if sFile==#-1
		return
	endif
	execute("colorscheme " . sFile)
endfunction

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
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
		"exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    endif
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
	let lstPath=keys(g:g_ProPaths)
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

function! TxtWrap()
    if &filetype=="txt"||&filetype=="text"
        execute("set wrap")
        silent echo "set wrap .".&filetype
    else
        execute("set nowrap")
        silent echo ".".&filetype." wrap reback"
    endif
endfunction

function! FileMapChange()
    if &filetype=="py"||&filetype=="python"
        nnoremap <leader>ad oprint "wzytxt======",
        nnoremap <leader>dd :g/^.*print\ "wzytxt=.*$/d<cr>
    elseif &filetype=="java"
		nnoremap <leader>ad oSystem.out.println("wzytxt======");<left><left><left>
        nnoremap <leader>dd :g/^.*println("wzytxt=.*$/d<cr>
    elseif &filetype=="c"||&filetype=="cpp"
		nnoremap <leader>ad oprintf("wzytxt======\n");<left><left><left><left><left>
        nnoremap <leader>dd :g/^.*printf("wzytxt=.*$/d<cr>
    endif
endfunction

function! SourceAllVimSetting()
	execute("source $VIMFILE")
	if g:OS#mac
		execute("source $GVIMFILE")
    else
	    execute("source $MYSETTING")
	endif
endfunction

function! OpenAllVimSetting()
	execute("only")
	execute("e $VIMFILE")
	execute("vs  $MYSETTING")
	if g:OS#mac
		execute("vs $GVIMFILE")
	endif
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
    let g:g_TagPath=g:g_CurDB . '\systag'
    let g:g_CSOut=g:g_CurDB . '\cscope.out'
    let g:g_CSFiles=g:g_CurDB . '\cscope.files'

    if !filereadable(g:g_TagPath)
        call BuildTag(1)
    endif
    execute("set tags=" . g:g_TagPath)

    if g:g_UseCS==#1
        if !filereadable(g:g_CSOut)
            call BuildCS(1)
        silent! cscope kill -1
        execute("cs add " . g:g_CSOut)
        endif
    endif

	call OnChangePro(a:sNewPro)
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
	call TxtWrap()
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
    if g:OS#win
        call ChangePro(sNewPro)
    endif
endfunction

function! BeforeLeave()
	call KillSearch()
    call CloseLayout()
    call SaveSearch()
    call SaveBufMgr()
    if g:OS#win
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
    if g:OS#win
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
        call BasicLayout()
    endfor
    execute("tabn " . iCurTab)
endfunction

function! BasicLayout()
    call CloseLayout()
    MBEOpen
"    bo 10 copen 
"	execute("vs|e " . g:g_SysEffqf . "|filetype detect")
	execute("bo new " . g:g_SysEffqf . "|resize 5|set winfixheight|filetype detect")
    NERDTree
    execute("normal tl")
endfunction

function! NewSysEffqf()
	execute("bo new " . g:g_SysEffqf . "|resize 5|set winfixheight|filetype detect")
endfunction

function! CloseLayout()
    silent TlistClose    
    MBEClose
"    cclose
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
	if bufname(winbufnr(winnr('#')))=~'__Tag_List__'
		return
	endif
	if bufname(winbufnr(winnr()))=~'__Tag_List__'
		return
	endif
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
        if g:OS#win
		    "t_vb must set here
		    autocmd GUIEnter * set vb t_vb=
            autocmd QuickfixCmdPost make call QfMakeConv()
            autocmd BufWritePost * call BuildTag()  
            autocmd BufWritePost * call BuildCS()  
            autocmd WinEnter * call SysOnWinEnter()  
            autocmd BufReadPre * call BigFile(expand("<afile>"))  
        endif
    augroup END
endfunction
call InitAuGroup()


"keymap================================================================================

if g:OS#win
	nnoremap <F5> :call F5Func()<cr>

	nnoremap <F12> :!start explorer /select, %:p<cr>
	nnoremap <leader><Leader>n :call RenameCurFile("<C-R>=expand("%:t")<CR>")
	nnoremap <leader><Leader>d :call DelCurFile()<cr>
	nnoremap <A-w> :q<cr>
	vnoremap <A-w> :q<cr>
else
	nnoremap <F5> :call CompileAndRun()<cr>

	nnoremap <c-s> :w!<cr>
	vnoremap <c-s> :w!<cr>
endif

"布局
nnoremap <F2> :call OnlyTabBuff()<cr> 
nnoremap <F3> :tabnew\|call ClearTabBufs()\|call BasicLayout()<cr>
nnoremap <F4> :call CloseLayout()\|tabc\|call ClearNoUseBuff()<cr>
nnoremap <Leader>lo :call BasicLayout()<cr>

"改变配色
nnoremap <Leader>cc :call ChangeScheme()<cr>

"文件
nnoremap <leader>ov :e $VIMFILE<cr>
nnoremap <leader>op :e $VIM/userdata/pros<cr>
nnoremap <leader>om :e $MYSETTING<cr>
nnoremap <leader>oa :call OpenAllVimSetting()<cr>
nnoremap <leader>ua :call SourceAllVimSetting()<cr>
nnoremap <leader>ec :execute("vsplit " . $VIMFOLDER.'\colors\health.vim')<CR> 
nnoremap <leader>em :messages<cr>
nnoremap <leader>es :execute("vsplit " . $VIM . '\vimfiles\UltiSnips\all.snippets')<CR>

"输入
nnoremap <leader>at :call AddModifyTime()<cr>
nnoremap <leader><leader>a :call AntiPEP8()<cr>
nnoremap rr :%s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>/g<Left><Left>

"map
nnoremap <leader>ss :execute("w\|source " . expand("%:p"))<CR> "保存加载当前文件

nnoremap L $
nnoremap H ^
vnoremap L $
vnoremap H ^

nnoremap <A-Right> :vertical res +1\|set winfixwidth<cr>
nnoremap <A-Left> :vertical res -1\|set winfixwidth<cr> 
nnoremap <A-Up> :res -1\|set winfixheight<cr>
nnoremap <A-Down> :res +1\|set winfixheight<cr>

nnoremap <F11> :NERDTreeFind<cr>
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
inoremap （ （）<left>

"use imap do not need type cr when complete 
imap <c-k> <Up>
imap <c-j> <Down>
imap <c-h> <Left>
imap <c-l> <Right>

"map
nnoremap tl :TlistClose<CR>:TlistToggle<CR>
nnoremap tlc :TlistClose<CR>

"goto
nnoremap <Leader>gq :call GotoWindow("sys.effqf")<cr> 
nnoremap <Leader>gt :call GotoWindow("NERD_tree")<cr> 
nnoremap <Leader>gm :call GotoWindow("-MiniBufExplorer-")<cr> 
nnoremap <Leader>gl :call GotoWindow("__Tag_List__")<cr> 
nnoremap <Leader>ge :call GotoEffqfLine()<cr>
nnoremap <Leader>p :wincmd }<cr>
nnoremap <Leader>cp :pclose<cr>


