#
# Control Panel for my Task tracker 
#


#main method control panel
def control_panel
	#initialize choice as 0
	choice = 0
	#start the loop 
	while choice != 4	
		#Let's tell the user what their options are...
		puts "OPTIONS:"
		puts "1. Open Tracking File"
		puts "2. Check-in to a task."
		puts "3. Refresh Tracking File"
		puts "4. Exit"
		#now prompt for input
		choice = gets.chomp.to_i
		#and let's do what the user wants		
		case
			when choice == 1
				#open the tracking file in a new firefox tab
				`firefox tracktivity.html`
			when choice == 2
				#load and run checkin.rb
				path = File.join(Dir.getwd,'checkin.rb')
				load path
			when choice == 3
				#wipe and rebuild the tracking file
				cleanup = File.join(Dir.getwd,'cleanup.rb')
				load cleanup
				build = File.join(Dir.getwd,'task-tracker.rb')
				load build
			when choice == 4
				puts "Adios muchacho(a)."
		end #end case
	end #end while
end #end control_panel
		



