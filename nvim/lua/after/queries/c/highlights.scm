[
  "define"
  "undef"
  "include"
  "if"
  "ifdef"
  "ifndef"
  "else"
  "elif"
  "endif"
  "error"
  "pragma"
] @preproc.directive

(#match? @preproc.directive "^(define|undef|include|if|ifdef|ifndef|else|elif|endif|error|pragma)$")
