var initial_profession_order;
jQuery(function(){
	jQuery('#professions').sortable({
		axis:'y', 
		dropOnEmpty:false, 
		handle:'img.handle', 
		update:function(event,ui){compare_profession_order()},
		items:'tr.profession.row'
	});

	jQuery('#save_order').disable();

	initial_profession_order = profession_order();

	jQuery('form#order_professions').submit(function(){
		if( initial_profession_order == profession_order() ) {
			/*
				Shouldn't get here as button should 
				be disabled if not different!
			*/
			alert("Profession order hasn't changed. Nothing to save.");
			return false
		} else {
			new_action = jQuery(this).attr('action');
			if( (/\?/).test(new_action) ){
				new_action += '&';
			} else {
				new_action += '?';
			}
			new_action += profession_order();
			jQuery(this).attr('action',new_action);
		}
	})

});

function profession_order() {
	return jQuery('#professions').sortable('serialize',{key:'professions[]'});
}

function compare_profession_order(){
	if( initial_profession_order == profession_order() ) {
		jQuery('#save_order').disable();
	} else {
		jQuery('#save_order').highlight(4000);
		jQuery('#save_order').enable();
	}
}
