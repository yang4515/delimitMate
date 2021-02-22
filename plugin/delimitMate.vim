function! AutoPair(open, close)
  let line = getline('.')
  let cc = col('.') - 1
  if cc >= strlen(line) - 1 || line[cc] == ' '
    return a:open.a:close."\<ESC>i"
  endif
  return a:open
endf

function! ClosePair(char)
  let line = getline('.')
  let cc = col('.') - 1
  if line[cc] == a:char
    return "\<Right>"
  endif
  return a:char
endf

function! SamePair(char)
  let line = getline('.')
  let cc = col('.') - 1
  let current_char = line[cc]
  let pre_char = line[cc - 1]

  if strlen(line) == 0 || pre_char == ' ' || pre_char == '(' || pre_char == '['
    return a:char.a:char."\<ESC>i"
  else
    if current_char == a:char
      return "\<Right>"
    endif
  endif
  return a:char
endf

function! IsPair(left, right)
  return (a:left == '(' && a:right == ')') || (a:left == '[' && a:right == ']') || (a:left == '{' && a:right == '}')
endf

function! IsSamePair(left, right)
  return (a:left == '`' && a:right == '`') || (a:left == "'" && a:right == "'") || (a:left == '"' && a:right == '"')
endf

function! Bs()
  let line = getline('.')
  let cc = col('.') - 1
  let left = line[cc - 1]
  let right = line[cc]

  if IsPair(left, right) || IsSamePair(left, right)
    return "\<right>\<bs>\<bs>"
  endif

  return "\<bs>"
endf

function! Space()
  let line = getline('.')
  let cc = col('.') - 1
  let left = line[cc - 1]
  let right = line[cc]

  if IsPair(left, right)
    return "\<space>\<left>\<space>"
  endif

  return "\<space>"
endf

function! Cr()
  let line = getline('.')
  let cc = col('.') - 1
  let left = line[cc - 1]
  let right = line[cc]

  if IsPair(left, right)
    return "\<cr>\<esc>\<up>o"
  endif
  return "\<cr>"
endf

inoremap <silent> ( <c-r>=AutoPair('(', ')')<cr>
inoremap <silent> ) <c-r>=ClosePair(')')<cr>
inoremap <silent> { <c-r>=AutoPair('{', '}')<cr>
inoremap <silent> } <c-r>=ClosePair('}')<cr>
inoremap <silent> [ <c-r>=AutoPair('[', ']')<cr>
inoremap <silent> ] <c-r>=ClosePair(']')<cr>
inoremap <silent> " <c-r>=SamePair('"')<cr>
inoremap <silent> ' <c-r>=SamePair("'")<cr>
inoremap <silent> ` <c-r>=SamePair('`')<cr>
inoremap <silent> <bs> <c-r>=Bs()<cr>
inoremap <silent> <cr> <c-r>=Cr()<cr>
inoremap <silent> <space> <c-r>=Space()<cr>
