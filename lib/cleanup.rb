def cleanup
	html = File.join(Dir.getwd,"tmp/tracktivity.html")
	css = File.join(Dir.getwd,"tmp/stylesheet.css")
	nav = File.join(Dir.getwd,"tmp/navigation.html")
	unless !(File.exist?(html))
		File.delete(html)
	end
	unless !(File.exist?(css))
		File.delete(css)
	end
	unless !(File.exist?(nav))
		File.delete(nav)
	end
end

cleanup
