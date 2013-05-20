#def day_start
	#`gedit Desktop/rad.txt Desktop/tracktivity.txt`
	#`firefox http://www.hulu.com`
	
#end


#Initialize the Activity Tracking File
def html_init
	#If the file doesn't yet exist, build it
	unless File.exist?("tracktivity.html")
		#Building the file for the first time
		#Accomplished by combining the header and footer HTML files in the templates directory		
		template_path = File.join(Dir.getwd,"templates")
		header_path = File.join(template_path,"header.html")
		footer_path = File.join(template_path,"footer.html")
		#open the header file	
		file = File.open(header_path)
		#store the contents as a string in header		
		header = file.read
		#close the file		
		file.close
		#open the footer file
		file = File.open(footer_path)
		#store the contents as a string in footer
		footer = file.read
		#close the file
		file.close
		#now let's get that data, format it, and use it as the body
		body = get_data_files
		#now create and write the new html file in the current directory
		new_path = File.join(Dir.getwd, "tracktivity.html")
		new_file = File.open(new_path, 'w') do |nf|
			#first write the header
			nf.puts header
			#then the body
			nf.puts body
			#then the footer
			nf.puts footer
		end #close the file, end the do
	end #end unless
end #end html_init
		

#Initializing the Activity Tracker CSS file
# prog_value = progress bar value on scale of 0 to 100
def css_init
	#If the file doesn't exist, build it.
	unless File.exist?("stylesheet.css")
		#the base stylesheet is in the templates directory
		template_path = File.join(Dir.getwd,"templates")
		css_path = File.join(template_path, "style-base.css")
		#open the file		
		file = File.open(css_path)
		#store the contents as a string in css		
		css = file.read
		#close the file		
		file.close
		#create the new file for writing, first establish path
		new_path = File.join(Dir.getwd, "stylesheet.css")
		new_file = File.open(new_path, 'w') do |nf|
			nf.puts css
		end #end the do, close the file
	end #end unless
end #end css_init

#This method will collect all of the .csv files from the data directory
#and pass them through the necessary methods for data extraction and formatting
#returns a big string of all activities formatted in HTML
def get_data_files
	#let's start up that final string
	big_activity_string = ""
	#first, change the directory to "data"
	Dir.chdir("data")
	#now, we're going to put all files ending in .csv into an array
	all_files = Dir['*.csv']
	#let's change the Dir back to the home dir
	Dir.chdir("..")
	#let's start the bidding at 0
	count = 0
	#and loop through that array
	while count < all_files.size
		#Extract the data from the file
		task_data = extract_task_data(all_files[count])
		#pass the extracted data to the HTML formatter
		#first, let's take out the name and the entries
		this_name = task_data[0]
		this_entries = task_data[1]
		#then we'll use the sections and entry count to calculate a percent
		#convert from string to float
		this_entry_count = task_data[2].to_f		
		this_sections = task_data[3].to_f
		#convert to integer after division so we're working with nice whole numbers
		this_percent = (this_entry_count / this_sections) * 100
		this_percent_int = this_percent.to_i
		this_html = format_data(this_name,this_entries,this_percent_int)
		#append that to the final string
		big_activity_string << this_html
		#update the CSS using name and percent
		update_css(this_name,this_percent_int)
		#increment the count
		count += 1
	end
	#and finally, return the string with all of the html
	big_activity_string
end #end get_data_files

#This method will extract the task information
#from individual .csv files
def extract_task_data(file_name)
	#let's open that sucker up
	file_path = File.join("data",file_name)
	file = File.open(file_path)
	#the first line is the header
	#[0] = task name, [1] = total sections
	header = file.readline.chomp.split(',')
	task_name = header[0]
	section_count = header[1]
	#now we're going to count the number of entries (rows)
	entry_count = 0	
	#and we're going to store the info as a matrix
	#and this matrix begins as a humble array	
	activity_array = []
	#now to loop through the file, keeping track of position with bytes
	#luckily, file.pos is re-evaluated every time and we don't have to manually update
	while file.pos < file.size
		#rows of activity_array are in this format:
		#[0] = description, [1] = date, [2] = time
		activity_array << file.readline.chomp.split(',')
		#update entry_count		
		entry_count += 1
	end #this loop is ovvaaahhh!
	#now let's return all of this in one big array
	#[0] = task name, [1] = activity array, [2] = entires, [3] = total sections
	result_array = [task_name, activity_array, entry_count, section_count]
	#I'm not sure if this is redundant but I'm going to put it here anyway
	result_array
end
		
#format the task data into HTML
def format_data(name,entries,percent)
	#this method is fairly straightforward
	#it's going to result in a string of HTML
	#first let's make the name into a useful id
	html_name = name.downcase.split.join('-')
	result_html = "<div class='activity'><h2>#{name}</h2><div id='#{html_name}-progbar' class='progbar'><div>#{percent}%</div></div><br /><h3>Activity Entries:</h3>"
	#now we're going to loop through the entries and append them as paragraphs
	#fire up a counter
	count = 0
	while count < entries.size
		entry = entries[count].join(" - ")
		result_html << "<p>#{entry}</p>"
		#update the count
		count += 1
	end
	#close up that HTML 
	result_html << "</div><br /><br />"
	#once again, don't know if this is redundant but... 
	result_html
end

#this method will update the CSS file, nothing is returned
def update_css(name, percent)
	#create the string of CSS
	#make that name nice again...
	css_name = name.downcase.split.join('-')
	update_string = %Q{ 
		##{css_name}-progbar div {
			width: #{percent}%;
		}}
	#get the path to the file
	css_path = File.join(Dir.getwd, "stylesheet.css")
	#open it up and append the update_string	
	css_file = File.open(css_path, "a") do |cf|
		cf.print update_string
	end #end do, close file
end #end update_css
	


def startup
	#CSS has to get initialized first
	#because the file is appended with the activity info
	#only after the HTML is initialized	
	css_init
	html_init

	`firefox tracktivity.html`
end

startup
				

 
			


