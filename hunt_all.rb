require_relative 'common_funcs.rb'
require_relative 'Point4D.rb'
require_relative 'Spreadsheet.rb'

# first document to attempt pulling data from spreadsheet

# Values specfic to planet
Planet_info = [ { owner: 'BruteForce', planet: 'BFTP', alive: 0 },
				{ owner: 'Doctor Who', planet: 'DWHO', alive: 1 },
				{ owner: 'Bingboing', planet: '4DTS', alive: 0 },
				{ owner: 'ElDucky', planet: 'SMPR', alive: 0 },
				{ owner: 'Kangaz wit Attitude', planet: 'WF69', alive: 1 },
				{ owner: 'Meshuga', planet: 'MIZ5', alive: 0 },
				{ owner: 'Aractuary', planet: 'HYPN', alive: 1 },
				{ owner: 'Vorian Atreides', planet: 'TDHM', alive: 0 },
				{ owner: 'Stillgreen', planet: 'LILG', alive: 1 },
				{ owner: 'Werewolf', planet: 'MAGA', alive: 1 },
				{ owner: 'E. Blackadder', planet: 'DEBB', alive: 0 },
				{ owner: 'vividox', planet: 'REEK', alive: 0 },
				{ owner: 'soyleche', planet: 'SOYL', alive: 0 }]

# Values common to all files of this type
Public_data = Spreadsheet.new(EXCL + 'tw_201601_round09.xlsx')
X = 4
Y = 5
Z = 6
T = 7

def planet_data(planet_name, owner, status)
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
					if (row[loc] == status * 3 or row[loc].strip == status) and row[0] != owner
						misses.push(Point4D.new(row[X], row[Y], row[Z], row[T])) 
					end
				end
			end
		end
	end
	return misses
end

def hunt(planet, owner)
	# hunts for given planet, returns set of possible points
	misses = planet_data(planet, owner, 'X')
	glancing_blows = planet_data(planet, owner, 'G')
	near_misses = planet_data(planet, owner, 'N')
	if near_misses.length > 0 then
		possible = near_misses[0].point_set(10)
	elsif glancing_blows.length > 0 then
		possible = glancing_blows[0].point_set(30)
	else
		#puts "ERROR: No definite data found"
		return []
	end
	glancing_blows.each { |pt| possible = pt.within_set(possible, 30, 10) }
	near_misses.each { |pt| possible = pt.within_set(possible, 10 ,3) }
	misses.each { |pt| possible = pt.without_set(possible, 30) }
	return possible
end

def volley_generation(possible)
	# generates random volleys and checks against coverage of possible space for planet
	(0...20).each do |i|
		# sample of 10, within 10 and 3
		sample, nm, hit = get_volley(possible, 10, 10, 3) 
	
		puts sample
		puts "#{(100*nm).round(2)}% points in near miss range"
		puts "#{(100*hit).round(2)}% points in hit range"
		puts "out of #{possible.length} total points"
	end
end

def hunt_all()
	# iterates all available information and outputs 20 guesses for each planet with info
	possibles = Hash.new()
	Planet_info.each do |planet|
		if planet[:alive] == 1
			possible = hunt(planet[:planet], planet[:owner])
			puts "#{planet[:owner]}: #{possible.length}"
			possibles[planet[:owner]] = possible if possible.length > 0
		end
	end
	puts
	puts
	possibles.each do |k, v| 
		puts k
		volley_generation(v)
	end
	return nil
end

def misses_only(planet, owner)
	# returns miss list if there is no solid info on the planet
	misses = planet_data(planet, owner, 'X')
	glancing_blows = planet_data(planet, owner, 'G')
	near_misses = planet_data(planet, owner, 'N')
	return misses if near_misses.length == 0 and glancing_blows.length == 0
	return nil
end

def full_miss(point, misses)
	# returns true if point outside 30 of all misses
	misses.each { |pt| return false if pt.dist(point) < 30 }
	return true
end

def miss_hunter()
	# looks for planets without useful info -- slow
	miss_hash = Hash.new()
	possibles = Hash.new([])
	Planet_info.each do |planet|
		if planet[:alive] == 1
			misses = misses_only(planet[:planet], planet[:owner])
			miss_hash[planet[:owner]] = misses if misses
		end
	end
	#universe do |pt|
	#	miss_hash.each do |planet, misses|
	#		possibles[planet].push(pt) if full_miss(pt, misses)
	#	end
	#end 
	#possibles.each { |planet, pos| puts "#{planet}: #{pos.length}" }
	miss_hash.each { |k,v| puts "#{k}: #{v.length}" }
end

def Main()
	#hunt_all()
	miss_hunter()
end

now = Time.now
Main()
puts "Run time: #{Time.now - now}"