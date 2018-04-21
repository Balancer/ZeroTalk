Page.cmd("siteInfo", {}, (function(_this) {
	return function(site) {
		$("#forum_banner").html(site.content.settings.forum_banner);
//		console.log("Navbar==");
		navbar = site.content.settings.navbar;
//		console.log(navbar);

		html = ""
		for(var i in navbar) {
			if(html != "")
				html += " &middot; ";

			html += "<a href=\""+navbar[i][1]+"\">"+navbar[i][0]+"</a>";
		}

		$("#navbar").html("Forums: "+html);
	};
})(this));
