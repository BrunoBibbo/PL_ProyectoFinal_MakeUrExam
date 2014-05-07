/* lexical grammar */
%{
var reserved_words ={ EXAMEN: 'EXAMEN', PREGUNTA: 'PREGUNTA', TEXTO: 'TEXTO', MULTI: 'MULTI', VF: 'VF', V: 'V', F: 'F' }

function idORrw(x) {
  return (x in reserved_words)? x : 'ID'
}

%}
%%

\s+|\#.*                         /* skip whitespace and comments */
"¿"				  return 'LEFTQ'
"?"				  return 'RIGHTQ'
\b([A-Z]+|[A-Z]?(([a-z]+|([+-]?\d+("."\d*)?([eE][-+]?\d+)?))\s?)*)\b                 return idORrw(yytext)
[-*/+^!%=();]                    return yytext;
<<EOF>>                          return 'EOF'
"."             	          return 'PUNTO'
