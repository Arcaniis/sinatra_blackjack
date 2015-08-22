$(document).ready(function() {

	$(document).on('click', 'form#hit_form input', function() {
		
		$.ajax({
			type: 'POST',
			url:  '/player_hit'
		}).done(function(msg) {
			$('#game').replaceWith(msg);
		});

		return false;
	});
});