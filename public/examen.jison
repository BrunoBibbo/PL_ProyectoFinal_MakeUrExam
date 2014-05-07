
%token ID PUNTO COMA PCOMA EXAMEN PREGUNTA TEXTO MULTI VF V F
/* Asociacion de operadores y precedencia (de menor a mayor) */

%start test

%% /* language grammar */

test
	: examen PUNTO
		{ 
			$$ = $1; 
			return [$$];
		}
	;

examen
	: EXAMEN ID preguntas
		{ $$ = { Tipo: $1, Nombre: $2, Preguntas: $3 }; }
	;

preguntas
	: pregunta
		{ 
			$$ = $1;
		}
	;
	
pregunta
	: PREGUNTA LEFTQ ID RIGHTQ tiporespuesta pregunta
		{ $$ = [{ Pregunta: $2 + $3 + $4, Respuestas: $5 }].concat($6); }
	| PREGUNTA LEFTQ ID RIGHTQ tiporespuesta
		{ $$ = { Pregunta: $2 + $3 + $4, Respuestas: $5 }; }
	| PREGUNTA ID tiporespuesta pregunta
		{ $$ = [{ Pregunta: $2, Respuestas: $3 }].concat($4); }
	| PREGUNTA ID tiporespuesta
		{ $$ = { Pregunta: $2, Respuestas: $3 }; }
	;
	
tiporespuesta
	: TEXTO respuesta
		{ $$ = { Tipo: $1, Contenido: $2 }; }
	;

respuesta
	: ID
		{ $$ = $1; }
	;