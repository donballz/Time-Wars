require_relative 'common_funcs.rb'
require_relative 'Point4D.rb'
require_relative 'Spreadsheet.rb'

# first document to attempt pulling data from spreadsheet

# Values specfic to planet
PLANET = 'TDHM'
OWNER = 'Vorian Atreides'
Near_miss = Point4D.new(-10, 60, 15, -70) # mod knowledge, not fully public

# Values common to all files of this type
Public_data = Spreadsheet.new(EXCL + 'tw_201601_round06.xlsx')
X = 4
Y = 5
Z = 6
T = 7

def planet_data(planet_name, status)
	# gets data for planet given by status flag
	misses = []
	loc = nil
	Public_data.each_sheet do |s| 
		if s == 'ShotData'
			first_row = true
			Public_data.each_row do |row| 
				if first_row
					row.each { |cell| loc = row.index(cell) if cell == planet_name }
					first_row = false if loc
				else
					if (row[loc] == status+status+status or row[loc] == status) and row[0] != OWNER
						misses.push(Point4D.new(row[X], row[Y], row[Z], row[T])) 
					end
				end
			end
		end
	end
	return misses
end

def Main()
	possible = Near_miss.point_set(10)
	puts possible.length
	misses = planet_data(PLANET, 'X')
	glancing_blows = planet_data(PLANET, 'G')
	near_misses = planet_data(PLANET, 'N')
	glancing_blows.each { |pt| possible = pt.within_set(possible, 30, 10) }
	puts possible.length
	near_misses.each { |pt| possible = pt.within_set(possible, 10 ,3) }
	puts possible.length
	misses.each { |pt| possible = pt.without_set(possible, 30) }
	puts possible.length
	points = possible.length
	
	(0...20).each do |i|
	
		# sample of 10, within 10 and 3
		sample, nm, hit = get_volley(possible, 10, 10, 3) 
	
		#write(within30_10, 'elducky_possible')
		puts sample
		puts "#{(100*nm).round(2)}% points in near miss range"
		puts "#{(100*hit).round(2)}% points in hit range"
		puts "out of #{points} total points"
	end
end

now = Time.now
Main()
puts "Run time: #{Time.now - now}"