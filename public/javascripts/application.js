jQuery(function(){

	var root = (location.host == 'ccls.berkeley.edu')?'/clic':'';

	jQuery.getScript(root + '/users/menu.js');

/*
http://www.google.com/cse/docs/cref.html
*/

	(function(){
		var ga = document.createElement('script'); 
		ga.type = 'text/javascript'; 
		ga.async = true;
		ga.src = "http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en";
		var s = document.getElementsByTagName('script')[0]; 
		s.parentNode.insertBefore(ga, s);
		/*
			This script adds the google watermark to the search box,
			as well as adding a 'siteurl' field to the form.
		$('#cse-search-box input[name=siteurl]').remove();
		*/
	})();

/*
	If a user make many multiple searches, the siteurl will
	continue to be appended to, which is just irritating.
	Unfortunately, I can't really stop google from doing it.
	Actually, we could by copying in the 'brand' javascript,
	and just removing that part.
*/
	jQuery('form#cse-search-box').submit(function(){
		jQuery('form#cse-search-box input[name=siteurl]').remove();
	});


	jQuery('a.submenu_toggle').click(function(){
		jQuery(this).parent().next().toggle(500);
		jQuery(this).next().toggleClass('ui-icon-triangle-1-e');
		jQuery(this).next().toggleClass('ui-icon-triangle-1-s');
		return false;
	});


	if( typeof jQuery('textarea.tinymce').tinymce == 'function' ){
		jQuery('textarea.tinymce').tinymce({
			// Location of TinyMCE script
			script_url : root + '/javascripts/tiny_mce/tiny_mce.js',
	
			// General options
			theme : "advanced",
	
			// Theme options
			theme_advanced_buttons1 : "newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect,|,hr,link",
			theme_advanced_buttons2 : '',	// otherwise will use defaults
			theme_advanced_buttons3 : '',	// otherwise will use defaults
			theme_advanced_statusbar_location : "bottom",
			theme_advanced_toolbar_location : "top",
			theme_advanced_toolbar_align : "left",
//			theme_advanced_resizing : true,
	
//			width: '710px'

			// Example content CSS (should be your site CSS)
			content_css : root + "/stylesheets/layout.css"
		});
	}

});
