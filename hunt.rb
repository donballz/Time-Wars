require_relative 'common_funcs.rb'
require_relative 'Point4D.rb'
require_relative 'Spreadsheet.rb'
require_relative 'sql_store.rb'

# Values specfic to planet
Planet_info = [ { owner: 'Planet 1', planet: 'PL_1', alive: 0 },
				{ owner: 'Planet 2', planet: 'PL_2', alive: 0 },
				{ owner: 'Planet 3', planet: 'PL_3', alive: 0 },
				{ owner: 'Planet 4', planet: 'PL_4', alive: 0 },
				{ owner: 'Planet 5', planet: 'PL_5', alive: 1 },
				{ owner: 'Planet 6', planet: 'PL_6', alive: 0 },
				{ owner: 'Planet 7', planet: 'PL_7', alive: 0 },
				{ owner: 'Planet 8', planet: 'PL_8', alive: 0 },
				{ owner: 'Planet 9', planet: 'PL_9', alive: 0 },
				{ owner: 'Planet X', planet: 'PL_X', alive: 0 }]

# Values common to all files of this type
Public_data = Spreadsheet.new(EXCL + 'tw_201703_round06.xlsx')
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

def full_miss(point, misses)
	# returns true if miss volley has miss status for all misses
	misses.each do |status, volleys| 
		volleys.each { |v| return false if v.status(point) != status }
	end
	return true
end

def miss_hunter(planet)
	# looks for planets without useful info -- slow
	possible = []
	misses = planet_data(planet)
	#misses.each { |k,v| return [] unless k == 'X' or k == 'XXX' }
	universe(3) {|pt| possible.push(pt) if full_miss(pt, misses)} 
	puts "writing #{possible.length} points to #{planet} in zip-3"
	#to_sql(possible, planet)
	return possible
end

def hunt(planet, owner)
	# hunts for given planet, returns set of possible points
	voll_data = planet_data(planet)
	possible = Point4D.new(-6,-59,-72,-26).point_set(GB) # deduced data required to hunt 5
	AllStatus.each do |status|
		if voll_data.key?(status)
			voll_data[status].each { |v| possible = v.status_check(possible, status) }
		end
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

def volley_optimization(possible, current)
	# attempts to find best available volley one point at a time. Recursive
	best_available = Point4D.new(0,0,0,0)
	best_cnt = 0
	possible.each do |test_pt|
		cnt = 0
		possible.each { |pt| cnt +=1 if test_pt.dist(pt) <= HT }
		if cnt > best_cnt
			best_available = test_pt 
			best_cnt = cnt 
		end
	end
	current.push(best_available)
	if current.length == 10
		return current
	else
		return volley_optimization(best_available.without_set(possible, HT), current)
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
	#hunt_all()
	#optimize_all()
	possible = miss_hunter('PL_9')
	#planet_data('PL_9').each { |k,v| puts "#{k}: #{v.length}" }
end

now = Time.now
Main()
puts "Run time: #{Time.now - now}"