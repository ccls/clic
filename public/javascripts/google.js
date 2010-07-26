jQuery(function(){
/*
	http://www.google.com/cse/docs/cref.html
*/
/*
	source_file = 
		"http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en";
	document.head.write(
		unescape(
			"%3Cscript src='" + source_file + 
			" type='text/javascript'%3E%3C/script%3E"));
*/

s.src = "http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en";
document.getElementsByTagName('head')[0].appendChild(s);

});
