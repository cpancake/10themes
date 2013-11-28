$(document).ready(function(){
	if(document.getElementById('input_inline') != null)
		$('#input_inline').autoGrow();
	$('#response_area').autosize();
	$('.rate-button').each(function() {
		$(this).attr('type', 'button');
		$(this).on('click', function() {
			var resp_id = $(this).attr('data-resp-id');
			$.post('/term/response/rate', {resp_id: resp_id, ajax: true}, function(data){
				data = $.parseJSON(data);
				$('#resp-votes-id' + resp_id).text(data['rating'] + ' Like' + (data['rating'] == 1 ? '' : 's'));
			});
			if($(this).val() == '(like)') 
				$(this).val('(unlike)');
			else
				$(this).val('(like)');
		});
	});
});