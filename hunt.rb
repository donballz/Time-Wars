require_relative 'common_funcs.rb'
require_relative 'Point4D.rb'
require_relative 'Spreadsheet.rb'
require_relative 'sql_store.rb'

# Values specfic to planet
Planet_info = [ { owner: 'Planet 1', planet: 'PL_1', alive: 1 },
				{ owner: 'Planet 2', planet: 'PL_2', alive: 1 },
				{ owner: 'Planet 3', planet: 'PL_3', alive: 0 },
				{ owner: 'Planet 4', planet: 'PL_4', alive: 0 },
				{ owner: 'Planet 5', planet: 'PL_5', alive: 0 },
				{ owner: 'Planet 6', planet: 'PL_6', alive: 1 },
				{ owner: 'Planet 7', planet: 'PL_7', alive: 0 },
				{ owner: 'Planet 8', planet: 'PL_8', alive: 0 },
				{ owner: 'Planet 9', planet: 'PL_9', alive: 0 },
				{ owner: 'Planet X', planet: 'PL_X', alive: 0 }]

# Values common to all files of this type
Public_data = Spreadsheet.new(EXCL + 'tw_201703_round07.xlsx')
# All possible hunt statuses, in specific order to maximize efficient search
AllStatus = ['N','NNN','NNG','NNX','NGG','NGX','NXX','G','GGG','GGX','GXX','X','XXX']
# Excel column numbers
V = 2 # Volley num
X = 4
Y = 5
Z = 6
T = 7

def planet_data(planet_name)
	# gets full data for planet given by hashed by distance report
	# assumes clean data !!
	vols = Hash.new([]) # keys are status, values are point sets
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
							vols[row[loc].strip] += [point] 
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
	return vols
end

def full_match(point, voll_stats)
	# returns true if volley matches status for all volley-status combos
	AllStatus.each do |s|
		if voll_stats.key?(s)
			voll_stats[s].each { |v| return false if v.status(point) != s}
		end
	end
	return true
end

def make_possible(volleys)
	# creates initial possibility sphere in zip-3
	possible = []
	universe(3) {|pt| possible.push(pt) if full_match(pt, volleys)} 
	return possible
end

def hunt(planet, owner)
	# hunts for given planet, returns set of possible points
	volleys = planet_data(planet)
	if false
		# manually entered data change ^ to true to use
		# currently hunting: 5
		possible = Point4D.new(-6,-59,-72,-26).point_set(GB) 
	elsif exists(planet)
		backup(planet)
		possible = fr_sql(planet)
	else
		possible = make_possible(volleys)
	end
	if true
		# set to true to factor in a smartbomb
		roo = Point4D.new(68,54,-19,32) # hits planet 8, misses all others
		possible = roo.smartbomb(possible, 'X')
	end
	AllStatus.each do |status|
		if volleys.key?(status)
			volleys[status].each { |v| possible = v.status_check(possible, status) }
		end
	end
	# below not ready. would need to pass and capture a format indicator
# 	if possible.length <= 10 ** 5
# 		possible = unzip(possible)
# 	end
	puts "writing #{possible.length} points to #{planet} in zip-3"
	to_sql(possible, planet)
	return possible
end

def coverage_output(metrics, pt_cnt)
	# func to output the coverage stats
	puts "#{(100*metrics[0]).round(2)}% points in glancing blow range"
	puts "#{(100*metrics[1]).round(2)}% points in near miss range"
	puts "#{(100*metrics[2]).round(2)}% points in hit range"
	puts "out of #{pt_cnt} total points"
end

def volley_generation(possible, size=10)
	# generates random volleys and checks against coverage of possible space for planet
	n = 20 # number of volleys to generate
	m = 3  # number of volleys to print
	volleys = {}
	ranks = []
	(0...n).each do |i|
		# sample of <size>, within 30, 10 and 3
		sample, metrics = get_volley(possible, size, [GB, NM, HT])
		tot =  metrics.reduce(0, :+) # sum of hit percetages
		volleys[tot] = [sample, metrics]
		ranks.push(tot)
	end
	ranks.sort!.reverse!
	(0...m).each do |i|
		puts volleys[ranks[i]][0]
		coverage_output(volleys[ranks[i]][1], possible.length)
	end
end

def volley_optimization(possible, current)
	# attempts to find best available volley one point at a time. Recursive
	best = Point4D.new(0,0,0,0)
	best_cnt = 0
	possible.each do |test_pt|
		cnt = 0
		possible.each { |pt| cnt +=1 if test_pt.dist(pt) <= HT }
		if cnt > best_cnt
			best = test_pt 
			best_cnt = cnt 
		end
	end
	current.push(best)
	if current.length == 10
		return current
	else
		return volley_optimization(best.without_status(possible, 'H'), current)
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
		coverage_output(metrics, v.length)
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
	#hunt_all()
	optimize_all()
	#possible = fr_sql('PL_9')
	#volley_generation(possible, 7)
end

now = Time.now
Main()
puts "Run time: #{Time.now - now}"