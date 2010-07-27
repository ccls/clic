jQuery(function(){

	jQuery('button.link').click(function(){
		window.location.href = $(this).find('span.href').text();
	});

	jQuery('p.flash').click(function(){$(this).remove();});

/*
	var root = (location.host == 'ccls.berkeley.edu')?'/clic':''
	jQuery.getScript(root + 
		'/javascripts/cache_helper.js?caller=' +
		location.pathname.replace(new RegExp('^' + root),'') );
*/

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
	})();
});
