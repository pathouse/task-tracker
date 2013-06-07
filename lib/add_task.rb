require 'csv'


def prompt_user
	print "\nTask Name: "
	task_name = gets.chomp
	print "\nNumber of Sections: "
  sections = gets.chomp
	#create a new .csv file
	{:fname => task_name, :sects => sections}
end

def build_file(args)
	name = args[:fname].downcase.split.join("-")
	name << ".csv"
	path = File.join(Dir.getwd,"lib/data/#{name}")
	CSV.open(path, 'w') do |row|
		row << [args[:fname], args[:sects]]
	end
end

build_file(prompt_user)
