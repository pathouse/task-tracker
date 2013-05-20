#
# Control Panel for my Task tracker 
#


def wipe_n_rebuild
	#wipe and rebuild the tracking file
	cleanup = File.join(Dir.getwd,'cleanup.rb')
	load cleanup
	build = File.join(Dir.getwd,'task-tracker.rb')
	load build
end


#main method control panel
def control_panel
	#initialize choice as 0
	choice = 0
	#start the loop 
	while choice != 4	
		#Let's tell the user what their options are...
		puts "OPTIONS:"
		puts "1. Open Tracking File"
		puts "2. Check-in to a Task."
		puts "3. Manually Refresh Tracking File"
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
				#now wipe and rebuild file
				wipe_n_rebuild
			when choice == 3
				wipe_n_rebuild
			when choice == 4
				puts "Adios muchacho(a)."
		end #end case
	end #end while
end #end control_panel
		
control_panel


