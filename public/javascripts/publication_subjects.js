var initial_publication_subject_order;
jQuery(function(){
	jQuery('#publication_subjects').sortable({
		axis:'y', 
		dropOnEmpty:false, 
		handle:'img.handle', 
		update:function(event,ui){compare_publication_subject_order()},
		items:'tr.publication_subject.row'
	});

	jQuery('#save_order').disable();

	initial_publication_subject_order = publication_subject_order();

	jQuery('form#order_publication_subjects').submit(function(){
		if( initial_publication_subject_order == publication_subject_order() ) {
			/*
				Shouldn't get here as button should 
				be disabled if not different!
			*/
			alert("Publication_subject order hasn't changed. Nothing to save.");
			return false
		} else {
			new_action = jQuery(this).attr('action');
			if( (/\?/).test(new_action) ){
				new_action += '&';
			} else {
				new_action += '?';
			}
			new_action += publication_subject_order();
			jQuery(this).attr('action',new_action);
		}
	})

});

function publication_subject_order() {
	return jQuery('#publication_subjects').sortable('serialize',{key:'publication_subjects[]'});
}

function compare_publication_subject_order(){
	if( initial_publication_subject_order == publication_subject_order() ) {
		jQuery('#save_order').disable();
	} else {
		jQuery('#save_order').highlight(4000);
		jQuery('#save_order').enable();
	}
}
