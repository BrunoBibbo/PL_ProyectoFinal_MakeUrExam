
%token ID PUNTO COMA PCOMA EXAMEN PREGUNTA TEXTO MULTI VF V F
/* Asociacion de operadores y precedencia (de menor a mayor) */

%{ 
  var verdadero = 0;
  var falso = 0;
  
  var multi = 0;
  
  var nPregunta = 1;
  
  var total = 0;
  
  function sumarV() {
	verdadero++;
  }
  
  function sumarF() {
	falso++;
  }
  
  function sumarMulti(){
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
	if(falso == 0 || verdadero != 1)
		throw new Error("Verdadero-Falso mal definido. Ha de tener una respuesta verdadera y al menos una falsa.");
  }
  
  function comprobarMulti() {
	if(multi <= 1)
		throw new Error("Error! No pueden haber menos de dos respuestas");
	if(verdadero < 1)
		throw new Error("Error! Tiene que haber al menos una respuesta verdadera");
  }
%}

%start test

%% /* Gramatica */

test
	: examen EOF
		{ 
			resetVF();
			$$ = { HTML: "<div class='examen' align=left><form name='Prueba' id='prueba' method='post' action='#'>" + $1.HTML, Resultados: $1.Resultados };
			$$.HTML += "<br><input type='button' id='corregir' value='Corregir'><br></form></div>";
			resetVF();
			return [$$.HTML, $$.Resultados];
		}
	;

examen
	: EXAMEN DOSPUNTOS ID preguntas
		{ 
			$$ = { HTML: "<br><h1><b>" + $3 + "</b></h1><br>" + $4.HTML, Resultados: $4.Resultados }; 
		}
	;

preguntas
	: pregunta
		{ 
			var html = $1.HTML;
			var res;
			
			if($1.length > 1){
			  html = "<strong>" + 1 + "." + "</strong>" + $1[0].HTML + "<br><br>";
			  res = [$1[0].Resultados];
			  for(i = 1; i < $1.length; i++){
			    html += "<strong>" + (i+1) + "." + "</strong>" + $1[i].HTML + "<br><br>";
			    res.push($1[i].Resultados);
			  }
			}
			else{
			  var html = $1.HTML;
			  res = [$1.Resultados];
			}

			$$ = { HTML: html, Resultados: res }; 
		}
	;
	
pregunta
	: PREGUNTA LEFTQ ID RIGHTQ tiporespuesta pregunta
		{ 
		total = nPregunta;
		$$ = [{ HTML: "<strong>" + $2 + $3 + $4 + "</strong><br>" + $5.HTML, Resultados: $5.Resultados }].concat($6);
		}
	| PREGUNTA LEFTQ ID RIGHTQ tiporespuesta
		{ 
		total = nPregunta;
		$$ = { HTML: "<strong>" + $2 + $3 + $4 + "</strong><br>" + $5.HTML + "<br>", Resultados: $5.Resultados }; 
		}
	| PREGUNTA ID DOSPUNTOS tiporespuesta pregunta
		{ 
		total = nPregunta;
		$$ = [{ HTML: "<strong>" + $2 + $3 + "</strong><br>" + $4.HTML, Resultados: $4.Resultados }].concat($5);
		}
	| PREGUNTA ID DOSPUNTOS tiporespuesta
		{ 
		total = nPregunta;
		$$ = { HTML: "<strong>" + $2 + $3 + "</strong><br>" + $4.HTML + "<br>", Resultados: $4.Resultados };
		}
	;
	
tiporespuesta
	: TEXTO DOSPUNTOS respuesta
		{ 
		  $$ = { HTML: "<input type='text' id=" + (nPregunta-total) + " size='15' name=" + (nPregunta-total) + "><br>", Resultados: $3.Resultados };
		  nPregunta++;
		}
	| VF DOSPUNTOS respuestas_vf
		{ 
			comprobarRespVF();

			var html = $3[0].HTML;
			var res;
			res = [$3[0].Resultados];
			for(i = 1; i < $3.length; i++){
			  if($3[i] != undefined){
			    html += $3[i].HTML;
			    res.push($3[i].Resultados);
			  }
			}

			$$ = { HTML: html, Resultados: res };
			resetVF();
			nPregunta++;
		}
	| MULTI DOSPUNTOS respuestas_multi
	        { 
			comprobarMulti();
			resetMulti();
			
			var html = $3[0].HTML;
			var res;
			res = [$3[0].Resultados];
			for(i = 1; i < $3.length; i++){
			  if($3[i] != undefined){
			    html += $3[i].HTML;
			    res.push($3[i].Resultados);
			  }
			}

			$$ = { HTML: html, Resultados: res };
			resetMulti();
			nPregunta++;
		}
	;

respuesta
	: ID
		{ $$ = { HTML: $1, Resultados: $1 }; }
	;

respuestas_vf
	: /* empty */
	| V DOSPUNTOS ID respuestas_vf
		{ 
			sumarV();
			$$ = [{ HTML: "<input type='radio' id=" + (nPregunta-total) + " value='V' name=" + (nPregunta-total) + ">" + $3 + ".<br>", Resultados: 'V' }].concat($4);
		}
	| F DOSPUNTOS ID respuestas_vf
		{ 
			sumarF();
			$$ = [{ HTML: "<input type='radio' id=" + (nPregunta-total) + " value='F' name=" + (nPregunta-total) + ">" + $3 + ".<br>", Resultados: 'F' }].concat($4);
		}
	;
	
respuestas_multi
	: /* empty */
	| V DOSPUNTOS ID respuestas_multi
		{ 
			sumarV();
			sumarMulti();
			$$ = [{ HTML: "<input type='checkbox' id=" + (nPregunta-total) + " value='VM' name=" + (nPregunta-total) + ">" + $3 + ".<br>", Resultados: 'VM' }].concat($4);
		}
	| F DOSPUNTOS ID respuestas_multi
		{ 
			sumarMulti();
			$$ = [{ HTML: "<input type='checkbox' id=" + (nPregunta-total) + " value='FM' name=" + (nPregunta-total) + ">" + $3 + ".<br>", Resultados: 'FM' }].concat($4);
		}
	;