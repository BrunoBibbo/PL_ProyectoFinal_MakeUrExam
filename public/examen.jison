
%token ID PUNTO COMA PCOMA EXAMEN PREGUNTA TEXTO MULTI VF V F
/* Asociacion de operadores y precedencia (de menor a mayor) */

%{ 
  var verdadero = 0;
  var falso = 0;
  
  var multi = 0;
  
  function sumarV() {
	console.log("Entra en sumarV");
	verdadero++;
  }
  
  function sumarF() {
	console.log("Entra en sumarF");
	falso++;
  }
  
  function sumarMulti(){
	console.log("Entra en sumarMulti");
	multi++;
  }
  
  function resetVF() {
	verdadero = 0;
	falso = 0;
  }
  
  function resetMulti() {
	multi = 0;
	verdadero = 0;
  }
  
  function comprobarRespVF() {
	if(falso == 0)
		throw new Error("Error! No se ha detectado ninguna respuesta falsa");
	if(verdadero != 1)
		throw new Error("Error! No puede haber más de una respuesta verdadera o no se ha detectado ninguna respuesta verdadera");
  }
  
  function comprobarMulti() {
	if(multi <= 1)
		throw new Error("Error! No pueden haber menos de dos respuestas");
	if(verdadero < 1)
		throw new Error("Error! Tiene que haber al menos una respuesta verdadera");
  }
%}

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
			comprobarRespVF();
			resetVF();
			$$ = { Tipo: $1, Contenido: $2 };
		}
	| MULTI respuestas_multi
	        { 
			comprobarMulti();
			resetMulti();
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
			sumarV();
			$$ = [{ Tipo: $1, Respuesta: $2 }].concat($3);
		}
	| F ID respuestas_vf
		{ 
			sumarF();
			$$ = [{ Tipo: $1, Respuesta: $2 }].concat($3);
		}
	;
	
respuestas_multi
	: /* empty */
		{ $$ = []; }
	| V ID respuestas_multi
		{ 
			sumarV();
			sumarMulti();
			$$ = [{ Tipo: $1, Respuesta: $2 }].concat($3);
		}
	| F ID respuestas_multi
		{ 
			sumarMulti();
			$$ = [{ Tipo: $1, Respuesta: $2 }].concat($3);
		}
	;