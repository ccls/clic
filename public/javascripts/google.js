jQuery(function(){
/*
http://code.google.com/intl/en/apis/analytics/docs/tracking/gaTrackingOverview.html
*/

	var gaJsHost = (
		("https:" == document.location.protocol) ? 
			"https://ssl." : "http://www.");

var s=document.createElement('script');
s.type='text/javascript';
s.src = gaJsHost + "google-analytics.com/ga.js"
document.getElementsByTagName('head')[0].appendChild(s);

/*
	This hangs???
*/
/*
	document.write(
		unescape(
			"%3Cscript src='" + gaJsHost + 
			"google-analytics.com/ga.js' " +
			"type='text/javascript'%3E%3C/script%3E"));
*/
	try{
		var pageTracker = _gat._getTracker("UA-4075393-1");
		pageTracker._trackPageview();
	} catch(err) {}


/*

	I gotta figure this out as it causes page loading to hang.

	document.write(
		"<script src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'></script>"
	);
	var pageTracker = _gat._getTracker("UA-4075393-1");
	pageTracker._initData();
	pageTracker._trackPageview();
*/

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
