var root = '';	// kinda global

jQuery(function(){

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

	jQuery('div.facet_toggle a').click(function(){
		jQuery(this).parent().next().toggle(500);
		jQuery(this).prev().toggleClass('ui-icon-triangle-1-e');
		jQuery(this).prev().toggleClass('ui-icon-triangle-1-s');
		return false;
	});

	//	New RAILS 4 style
	if( typeof(tinymce) == 'object' ){	// don't do this unless a page loaded tinymce.js
		tinymce.init({
			selector:'textarea.tinymce',
			plugins: [
				"advlist autolink autosave link image lists charmap print preview hr anchor pagebreak spellchecker",
				"searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
				"table contextmenu directionality emoticons template textcolor paste fullpage textcolor"
			],

			toolbar1 : "newdocument | bold italic underline strikethrough | justifyleft justifycenter justifyright justifyfull formatselect fontselect fontsizeselect | forecolor backcolor",
			toolbar2 : 'bullist numlist | outdent indent | undo redo | subscript superscript | link unlink | image hr | charmap spellchecker',	// otherwise will use defaults
			toolbar3 : '',	// otherwise will use defaults

			menubar: false,
			toolbar_items_size: 'small',

			width : '100%',

			style_formats: [
				{title: 'Bold text', inline: 'b'},
				{title: 'Red text', inline: 'span', styles: {color: '#ff0000'}},
				{title: 'Red header', block: 'h1', styles: {color: '#ff0000'}},
				{title: 'Example 1', inline: 'span', classes: 'example1'},
				{title: 'Example 2', inline: 'span', classes: 'example2'},
				{title: 'Table styles'},
				{title: 'Table row 1', selector: 'tr', classes: 'tablerow1'}
			],

			link_list :  "/editor_links.js",
			image_list : "/editor_images.js",

			//		stops any url modification
			convert_urls : false,
			// Example content CSS (should be your site CSS)
			content_css : root + "/assets/layout.css"
		});
	}


	jQuery('a#add_attachment').click(function(){
		name = jQuery("input[name*='[group_documents_attributes]['][name$='][document]']").last().attr('name')
		resource = name.match(/^(\w+)\[/)[1];	// annual_meeting, doc_form, ...
		count = name.match(/\[(\d+)\]/)[1];	// '0', '1', ...
		next = parseInt(count) + 1;  // 1, 2, ...
/*
	would be cleaner if this was an AJAX request
*/
		jQuery('div#group_documents').append( "<hr/><div class='title text_field field_wrapper'><label for='"+resource+"_group_documents_attributes_"+next+"_title'>Document Title</label><input class='autosize' id='"+resource+"_group_documents_attributes_"+next+"_title' name='"+resource+"[group_documents_attributes]["+next+"][title]' size='30' type='text' /></div><!-- class='title text_field' --><div class='document file_field field_wrapper'><label for='"+resource+"_group_documents_attributes_"+next+"_document'>Document</label><input id='"+resource+"_group_documents_attributes_"+next+"_document' name='"+resource+"[group_documents_attributes]["+next+"][document]' size='30' type='file' /></div><!-- class='document file_field' -->"
);
		resize_text_areas();
	});

	jQuery('#tabs li a').click(function(){
		jQuery('#tabs li a').removeClass('current');
		jQuery(this).addClass('current');
		tab_content_id = '#'+jQuery(this).parent().attr('class');
		jQuery('.tab_contents').hide();
		jQuery(tab_content_id).show();
		return false;
	});


	jQuery('.modal_trigger').click(function(){
		if( typeof jQuery('#'+this.id+'_content').modal == 'function' ){
			jQuery('#'+this.id+'_content').modal();
			return false;
		}
	});

/*
	add_clic_prefix_to_links();
*/
});

/*

	Eventually, I hope, we will not be using paths.
	Until then, ensure that the links contain the /clic/ prefix

*/
/*
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
*/
