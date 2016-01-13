"align data in [**,***] or {**,**}
function! DataAlign()
    let lines =  getline(a:firstline, a:lastline) 
    let numLines = len(lines)
    "echo "totallines" . numLines
    "step 1, check it's [  or {
    let idxArray = stridx(lines[0], '[') 
    let idxDict = stridx(lines[0], '{') 
    if idxDict < 0 || idxArray > 0 && idxArray < idxDict 
	let dataType = '[]' 
	let delimi0 = '['
	let delimi1 = ']'
    else
	let dataType = '{}'
	let delimi0 = '{'
	let delimi1 = '}'
    endif 
    "echo delimi0 . delimi1
    let data = []
    let core = []
    let sizes = []
    "get data
    for i in range(0, numLines - 1)

	let index0 = stridx(lines[i], delimi0)
	let index1 = strridx(lines[i], delimi1)
	"echo index0 
	"echo index1
	call add(data, [])
	call add(data[i], strpart(lines[i], 0, index0 + 1))
	call add(data[i], strpart(lines[i], index0 + 1, index1 - index0 - 1))
	call add(data[i], strpart(lines[i], index1))
	"echo data[i]

	call add(core, split(data[i][1], ',\s*'))
	if i == 0
	    let sizes = sizes + map(deepcopy(core[0]), 'len(v:val)')
	    "echo sizes
	else
	    " get max sizes of each col
	    for j in range(0, len(sizes) - 1)
		let l = len(core[i][j])
		if(l > sizes[j])
		    let sizes[j] = l
		endif
	    endfor
	endif
    endfor
    "echo data
    "echo core
    "echo sizes
    
    "format
    for i in range(0, numLines - 1)
	for j in range(0, len(sizes) - 1)
	    let core[i][j] = StrLenTo(core[i][j], sizes[j], ' ')
	endfor
	let data[i][1] = join(core[i], ', ')
	call setline(a:firstline + i, data[i][0] . data[i][1] . data[i][2] )
    endfor
endfunction

" *mulFactor + addFactor for each item in list
function! DataTrans(list, mulFactor, addFactor)
    
    for i in range(0, len(a:list) - 1)
	let a:list[i] = a:list[i] * a:mulFactor + a:addFactor
    endfor

endfunction

"let list=[116,118, 137,142, 156,162, 180,174, 163,155, 191,181, 242,244]
"call DataTrans(list, 0.5, 0)

"compensate str with symbol until it's length is len
function! StrLenTo(str, len, symbol)

    let numSymbol = a:len - len(a:str) 
    let res = a:str

    while numSymbol > 0
	let res = res . a:symbol
	let numSymbol = numSymbol - 1
    endwhile

    return res
endfunction



"let s = StrLenTo('a', 5, '*')
"echo s

" copy into q and @q
":source %100GV3j:call DataAlign()




"[132, 72, 44, 31123, 0, 22  , 15.5],
"[88 , 2 , 4 , 31   , 0, 22  , 15.5],
"[44 , 72, 44, 31   , 0, 2222, 15.5],
"[0  , 72, 44, 31   , 0, 22  , 15.5]


