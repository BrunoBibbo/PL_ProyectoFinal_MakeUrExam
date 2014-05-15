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
		
			console.log(formulario);
			console.log(result[1]);
	  
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

  

