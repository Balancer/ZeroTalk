class Renderer extends marked.Renderer
	image: (href, title, text) ->
		if href.endsWith('.mp4')
			return "
<video controls>
	<source src=\"#{href}\" type=\"video/mp4\">
	Your browser does not support the video tag.
</video>"

		return "<img src=\"" + href + "\"/>"

#		return ("<code>![#{text}](#{href})</code>")

class Text
	toColor: (text) ->
		hash = 0
		for i in [0..text.length-1]
			hash += text.charCodeAt(i)*i
		return "hsl(" + (hash % 360) + ",30%,50%)";
		###
		for i in [0..2]
			value = (hash >> (i * 8)) & 0xFF
			color += ('00' + value.toString(16)).substr(-2)
		return color
		###


	toMarked: (text, options={}) ->
		options["gfm"] = true
		options["breaks"] = true
		options["renderer"] = renderer
		text = @fixReply(text)
		text = text.replace(/^(\s*- )\[ \]/m, "$1☐")
		text = text.replace(/^(\s*- )\[x\]/m, "$1☑")
		text = marked(text, options)
		return @fixHtmlLinks text


	# Convert zeronet html links to relaitve
	fixHtmlLinks: (text) ->
		if window.is_proxy
			back = text.replace(/href="http:\/\/(127.0.0.1|localhost):43110/g, 'href="http://zero')
			return back.replace(/http:\/\/zero\/([^\/]+\.bit)/g, "http://$1")  # Domain
		else
			return text.replace(/href="http:\/\/(127.0.0.1|localhost):43110/g, 'href="')


	# Convert a single link to relative
	fixLink: (link) ->
		if window.is_proxy
			back = link.replace(/http:\/\/(127.0.0.1|localhost):43110/, 'http://zero')
			return back.replace(/http:\/\/zero\/([^\/]+\.bit)/, "http://$1")  # Domain
		else
			return link.replace(/http:\/\/(127.0.0.1|localhost):43110/, '')


	toUrl: (text) ->
		return text.replace(/[^A-Za-z0-9]/g, "+").replace(/[+]+/g, "+").replace(/[+]+$/, "")

	fixReply: (text) ->
		return text.replace(/(>.*\n)([^\n>])/gm, "$1\n$2")

	toBitcoinAddress: (text) ->
		return text.replace(/[^A-Za-z0-9]/g, "")


	jsonEncode: (obj) ->
		return btoa(unescape(encodeURIComponent(JSON.stringify(obj, undefined, '\t'))))


window.is_proxy = (window.location.pathname == "/")
window.renderer = new Renderer()
window.Text = new Text()
