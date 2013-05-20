def cleanup
	html = File.join(Dir.getwd,"tracktivity.html")
	css = File.join(Dir.getwd,"stylesheet.css")
	unless !(File.exist?(html))
		File.delete(html)
	end
	unless !(File.exist?(css))
		File.delete(css)
	end
end

cleanup
