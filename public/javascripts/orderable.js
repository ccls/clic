/*
	I seriously doubt that this will work if there are 
	multiple orderables on a single page.

	This is currently only used by professions and publication_subjects,
	but would like to use it on others.

	Also, annual_meetings and groups
*/
var initial_order;
jQuery(function(){
	jQuery('.orderable').sortable({
		axis:'y', 
		dropOnEmpty:false, 
		handle:'img.handle', 
		update:function(event,ui){compare_order()},
		items:'tr.row'
	});

	jQuery('#save_order').disable();

	initial_order = order();

	jQuery('form#order').submit(function(){
		if( initial_order == order() ) {
			/*
				Shouldn't get here as button should 
				be disabled if not different!
			*/
			alert("Order hasn't changed. Nothing to save.");
			return false
		} else {
			new_action = jQuery(this).attr('action');
			if( (/\?/).test(new_action) ){
				new_action += '&';
			} else {
				new_action += '?';
			}
			new_action += order();
			jQuery(this).attr('action',new_action);
		}
	})

});

function order() {
	return jQuery('.orderable').sortable('serialize',{key:'ids[]'});
}

function compare_order(){
	if( initial_order == order() ) {
		jQuery('#save_order').disable();
	} else {
		jQuery('#save_order').highlight(4000);
		jQuery('#save_order').enable();
	}
}
