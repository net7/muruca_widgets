$(function(){
	// BUTTONS
	$('.fg-button').hover(
		function(){ $(this).removeClass('ui-state-default').addClass('ui-state-focus'); },
		function(){ $(this).removeClass('ui-state-focus').addClass('ui-state-default'); }
	);
});

function createPodMenu(options) {
	options.content = $('#class-menu-items-' + options.unique_id).html();
	if(options.crumbDefaultText == null) { options.crumbDefaultText = ' '; } 
	
	$('#class-menu-' + options.unique_id).menu(options);
};