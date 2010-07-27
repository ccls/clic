var googleSearchIframeName = "cse";
var googleSearchFormName = "cse-search-box";
var googleSearchFrameWidth = 600;
var googleSearchFrameHeight = 600;
var googleSearchDomain = "www.google.com";
var googleSearchPath = "/cse";

jQuery(function(){
	(function(){
		var ga = document.createElement('script'); 
		ga.type = 'text/javascript'; 
		ga.async = true;
		ga.src = "http://www.google.com/afsonline/show_afs_search.js";
		var s = document.getElementsByTagName('script')[0]; 
		s.parentNode.insertBefore(ga, s);
	})();
});
