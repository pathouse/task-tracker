#This part of the program will update an existing task

#general error class for any errors that I need to raise
class TaskFileError < StandardError
end

#This method will locate the .csv file of the task with the given name
#it then returns the name of that file as a string
def find_task_data(task_name)
	#first, let's format the name for comparison
	task_name = task_name.downcase.split.join('-')
	#now we're going to navigate to the data directory
	Dir.chdir("data")
	#let's pull all of the .csv files...
	all_files = Dir['*.csv']
	#pop back into the home directory
	Dir.chdir("..")
	#let's declare a variable that will soon hold the desired file...
	task_file = nil
	#iterate
	iter = all_files.each do |file|
		file_path = File.join("data",file)
		#we'll pop this file open to check the header info and see if the names match
		check = File.open(file_path) do |ch|
			header_info = ch.readline.split(',')
			#pull out just the name and format it the same way as before			
			header_name = header_info[0].downcase.split.join('-')
			if header_name == task_name
				task_file = file_path
				#we're done, we can call it quits here with an explicit return
				return task_file 
			end 
		end #end the do, close the file
	end #end iter do
	#if we made it this far, let's throw an error because that task doesn't exist
	raise TaskFileError, "Task file cannot be found, make sure you entered the name correctly."
end #and we're done

#this method takes the name of a task and a description of the checkin to update it's data
def task_checkin(task_name, description)
	#first, let's find the path for the file...
	task_data_path = find_task_data(task_name)
	#now that we have the path to the file, let's prepare the string we're going to append
	#let's capitalize description to make it look nice
	description.capitalize!
	#now we'll get the date and time and format it as an array
	dt = Time.now
	#now let's format the date into a string
	#Ruby is awesome and can do this for us
	#resulting string = "month/day/year,hours:minutes:seconds am/pm"
	dt_string = dt.strftime("%m/%d/%Y,%I:%M:%S %p")
	#now we append this to the description
	checkin_string = "#{description},#{dt_string}"
	#and update the file with it - open file with "a" to append
	update = File.open(task_data_path, "a") do |up|
		up.puts checkin_string
	end #end do, close file
	#return 0 to indicate success
	0
end

#This method will take input from the user to start a new checkin
def start_checkin
	#First, let's ask for the name of the task
	puts "Task Name:"
	t_name = gets.chomp
	#Now we'll ask for a description
	puts "Description:"
	t_desc = gets.chomp
	#and now we'll go to work...
	result = task_checkin(t_name, t_desc)
	if result == 0
		puts "Your task has been successfully updated." 
	end
end	

start_checkin

