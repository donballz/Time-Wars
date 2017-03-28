require_relative 'common_funcs.rb'
require_relative 'Point4D.rb'
require_relative 'Spreadsheet.rb'
require_relative 'sql_store.rb'

# Values specfic to planet
Planet_info = [ { owner: 'Planet 1', planet: 'PL_1', alive: 0 },
				{ owner: 'Planet 2', planet: 'PL_2', alive: 0 },
				{ owner: 'Planet 3', planet: 'PL_3', alive: 0 },
				{ owner: 'Planet 4', planet: 'PL_4', alive: 0 },
				{ owner: 'Planet 5', planet: 'PL_5', alive: 0 },
				{ owner: 'Planet 6', planet: 'PL_6', alive: 1 },
				{ owner: 'Planet 7', planet: 'PL_7', alive: 0 },
				{ owner: 'Planet 8', planet: 'PL_8', alive: 0 },
				{ owner: 'Planet 9', planet: 'PL_9', alive: 0 },
				{ owner: 'Planet X', planet: 'PL_X', alive: 0 }]

# Values common to all files of this type
Public_data = Spreadsheet.new(EXCL + 'tw_201703_round05_clean.xlsx')
# Excel column numbers
V = 2 # Volley num
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

def planet_data_full(planet_name)
	# gets full data for planet given by hashed by distance report
	# assumes clean data !!
	vols = Hash.new([]) # keys are status, values are point sets
	fours = Hash.new([]) # keys are status, values are points
	pts = []
	curvol = 'Volley 1'
	loc = nil
	report = 'QQQ'
	Public_data.each_sheet do |s| 
		if s == 'ShotData'
			first_row = true
			Public_data.each_row do |row|
				if first_row
					row.each { |cell| loc = row.index(cell) if cell == planet_name }
					first_row = false if loc
				else
					point = Point4D.new(row[X], row[Y], row[Z], row[T])
					if curvol == row[V]
						pts.push(point)
						report = row[loc]
					elsif pts.length == 3
						vols[report] += [Volley.new(*pts)]
						if row[V] != 'Volley 4'
							pts = [point] 
							curvol = row[V]
						else
							fours[row[loc].strip] += [point] 
							pts = []
							curvol = 'Volley 1'
						end
					else
						pts = []
						curvol = row[V]
					end
				end
			end
		end
	end
	return vols, fours
end

def hunt(planet, owner)
	# hunts for given planet, returns set of possible points
	voll_data, four_data = planet_data_full(planet)
	glancing_blows = planet_data(planet, owner, 'G')
	near_misses = planet_data(planet, owner, 'N')
	if near_misses.length > 0 then
		possible = near_misses[0].point_set(NM)
	elsif glancing_blows.length > 0 then
		possible = glancing_blows[0].point_set(GB)
	else
		raise 'Insufficient data'
	end
	#possible = Point4D.new(-6,-59,-72,-26).point_set(GB) # deduced data required to hunt 5
	four_data.each do |status, points|
		points.each { |pt| possible = pt.with_status(possible, status) }
	end
	voll_data.each do |report, volleys|
		volleys.each { |v| possible = v.within_set(possible, report) }
	end
	#to_sql(possible, planet)
	return possible
end

def volley_generation(possible)
	# generates random volleys and checks against coverage of possible space for planet
	n = 20 # number of volleys to generate
	m = 3  # number of volleys to print
	volleys = {}
	ranks = []
	(0...n).each do |i|
		# sample of 10, within 30, 10 and 3
		sample, metrics = get_volley(possible, 10, [GB, NM, HT])
		tot =  metrics.reduce(0, :+) # sum of hit percetages
		volleys[tot] = [sample, metrics]
		ranks.push(tot)
	end
	ranks.sort!.reverse!
	(0...m).each do |i|
		puts volleys[ranks[i]][0]
		puts "#{(100*volleys[ranks[i]][1][0]).round(2)}% points in glancing blow range"
		puts "#{(100*volleys[ranks[i]][1][1]).round(2)}% points in near miss range"
		puts "#{(100*volleys[ranks[i]][1][2]).round(2)}% points in hit range"
		puts "out of #{possible.length} total points"
	end
end

def optimize_all()
	# runs from sql tables, gives optimization volley for all alive planets. run hunt first.
	possibles = Hash.new()
	Planet_info.each do |planet|
		if planet[:alive] == 1
			possible = fr_sql(planet[:planet])
			puts "#{planet[:owner]}: #{possible.length}"
			possibles[planet[:owner]] = possible if possible.length > 0
		end
	end
	puts
	puts
	possibles.each do |k, v| 
		puts k
		sample = volley_optimization(v, [])
		metrics = get_volley_def(v, sample, [GB, NM, HT])
		puts sample
		puts "#{(100*metrics[0]).round(2)}% points in glancing blow range"
		puts "#{(100*metrics[1]).round(2)}% points in near miss range"
		puts "#{(100*metrics[2]).round(2)}% points in hit range"
		puts "out of #{v.length} total points"
	end
	return nil
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

def Main()
	hunt_all()
	#optimize_all()
end

now = Time.now
Main()
puts "Run time: #{Time.now - now}"