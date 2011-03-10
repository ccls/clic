jQuery(function(){

	var root = (location.host == 'ccls.berkeley.edu')?'/clic':'';
/*
	jQuery.getScript(root + '/pages/translate.js' )
*/
/*
		'/pages/translate.js?caller=' +
		location.pathname.replace(new RegExp('^' + root),'') );

*/
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

	jQuery('.datepicker').datepicker();

});
