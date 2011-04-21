var root = '';	// kinda global

jQuery(function(){

	root = (location.host == 'ccls.berkeley.edu')?'/clic':'';

	jQuery.getScript(root + '/users/menu.js',
		function(data,textStatus){
			add_clic_prefix_to_links('#PrivateNav');
		}
	);

/*
http://www.google.com/cse/docs/cref.html
*/

	(function(){
/*		IE 8 DOES NOT LIKE THIS
		var ga = document.createElement('script'); 
		ga.type = 'text/javascript';
		ga.async = true;
		ga.src = "http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en";
		var s = document.getElementsByTagName('script')[0]; 
		s.parentNode.insertBefore(ga, s);
*/
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
			plugins : "spellchecker",
	
			// Theme options
			theme_advanced_buttons1 : "newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,formatselect,fontselect,fontsizeselect,|,forecolor,backcolor",
			theme_advanced_buttons2 : 'bullist,numlist,|,outdent,indent,|,undo,redo,|,sub,sup,|,link,unlink,|,image,hr,|,charmap,spellchecker',	// otherwise will use defaults
			theme_advanced_buttons3 : '',	// otherwise will use defaults
			theme_advanced_statusbar_location : "bottom",
			theme_advanced_toolbar_location : "top",
			theme_advanced_toolbar_align : "left",
//			theme_advanced_resizing : true,
	
//			width: '710px',
//			width : '710',
			width : '100%',

//		stops any url modification
			convert_urls : false,

/*
	This doesn't work as advertised
			relative_urls : false,
			remove_script_host : true,
			document_base_url : "http://ccls.berkeley.edu/path1/",
*/

			external_link_list_url :  root + "/editor_links.js",
			external_image_list_url : root + "/editor_images.js",


			// Example content CSS (should be your site CSS)
			content_css : root + "/stylesheets/layout.css"
		});
	}

	add_clic_prefix_to_links();
});

/*

	Eventually, I hope, we will not be using paths.
	Until then, ensure that the links contain the /clic/ prefix

*/
function add_clic_prefix_to_links(container) {
	if(location.host == 'ccls.berkeley.edu') {
		a_tags = ( typeof(container) == 'undefined' ) ? 'a' : container + ' a';
		jQuery(a_tags).each(function(){
			var href = jQuery(this).attr('href');
			if( (/^\//).test(href) && !(new RegExp('^'+root)).test(href) ){
				jQuery(this).attr('href',root+href);
			}
		});
	}
}
