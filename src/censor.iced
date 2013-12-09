###!
censor
!###

censor = do ->
  # http://jrgraphix.net/research/unicode_blocks.php?block=8
  ALPHABET = {
    'C': '\u0421', 'c': '\u0441'
    'E': '\u0415', 'e': '\u0435'
    'I': '\u0406', 'i': '\u0456'
    'O': '\u041e', 'o': '\u043e'
    'P': '\u0420', 'p': '\u0440'
    'S': '\u0405', 's': '\u0455'
  }
  HIT = [
    'script(?=&gt;)'
  ]
  censor = (s) ->
    for hit in HIT
      s = s.replace ///#{hit}///ig, ($0) ->
        for own from, to of ALPHABET
          $0 = $0.replace(///#{from}///, to + '\u200b')
        $0
    s
