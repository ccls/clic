jQuery(function(){
	jQuery('.modal_trigger').click(function(){
		jQuery('#'+this.id+'_content').modal();
		return false;
	});
});
