$(document).ready(function() {
  $('#parse').click(function() {
    try {
      var result = examen.parse($('#input').val());
      $('#output').html(JSON.stringify(result[0],undefined,2));
	  $('#corregir').click(function() {
		try {
			var formulario = [document.getElementsByName("1")];
	  
			for(i = 2; i <= result[1].length; i++)
				formulario.push(document.getElementsByName(i.toString()));
		
			var tipoRespuesta;

			var cuantasV = 0;
			var contadorV = 0;
	  
			var resultado = 0;
	  
			var evitarError = "<div class='fin' align=left><br><p> El resultado obtenido ha sido de ".concat(resultado.toString().concat(" puntos.</p></div>"));
	  
			var resultadoTotal = result[0] + evitarError;
	  
			$('#output').html(JSON.stringify(resultadoTotal,undefined,2));
	  
		} catch (e) {
			$('#output').html('<div class="error"><pre>\n' + String(e) + '\n</pre></div>');
		}
	  });
    } catch (e) {
      $('#output').html('<div class="error"><pre>\n' + String(e) + '\n</pre></div>');
    }
  });

  $("#examples").change(function(ev) {
    var f = ev.target.files[0]; 
    var r = new FileReader();
    r.onload = function(e) { 
      var contents = e.target.result;
      
      input.innerHTML = contents;
    }
    r.readAsText(f);
  });

});

  

