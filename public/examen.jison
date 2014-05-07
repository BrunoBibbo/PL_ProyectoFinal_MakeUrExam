
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
	| VF respuestas_vf
		{ 
			$$ = { Tipo: $1, Contenido: $2 };
		}
	| MULTI respuestas_multi
	        { 
			$$ = { Tipo: $1, Contenido: $2 }; 
		}
	;

respuesta
	: ID
		{ $$ = $1; }
	;
	
respuestas_vf
	: /* empty */
		{ $$ = []; }
	| V ID respuestas_vf
		{ 
			$$ = [{ Tipo: $1, Respuesta: $2 }].concat($3);
		}
	| F ID respuestas_vf
		{ 
			$$ = [{ Tipo: $1, Respuesta: $2 }].concat($3);
		}
	;
	
respuestas_multi
	: /* empty */
		{ $$ = []; }
	| V ID respuestas_multi
		{ 
			$$ = [{ Tipo: $1, Respuesta: $2 }].concat($3);
		}
	| F ID respuestas_multi
		{ 
			$$ = [{ Tipo: $1, Respuesta: $2 }].concat($3);
		}
	;