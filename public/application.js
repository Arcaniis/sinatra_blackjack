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

	$(document).on('click', 'form#dealer_hit input', function() {
		
		$.ajax({
			type: 'POST',
			url:  '/dealers_turn'
		}).done(function(msg) {
			$('#dealer_game').replaceWith(msg);
		});

		return false;
	});
});