require_relative 'common_funcs.rb'
require_relative 'Point4D.rb'
require_relative 'Spreadsheet.rb'
require_relative 'sql_store.rb'

glance = Point4D.new(-18,17,-49,-43)
actual = Point4D.new(-35,14,-42,-66)

#puts glance.x
#puts glance.y
#puts glance.z
#puts glance.t

#possible = glance.point_set(30)

#possible.each { |pt| puts pt if pt == actual }

#puts actual.dist(glance)

#range = 30
#(glance.x - range..glance.x + range).each do |i|
#	(glance.y - range..glance.y + range).each do |j| 
#		(glance.z - range..glance.z + range).each do |k| 
#			(glance.t - range..glance.t + range).each do |l|
#				try = Point4D.new(i,j,k,l)
#				puts "#{try} dist: #{glance.dist(try)} origin: #{(i**2 + j**2 + k**2 + l**2)**0.5}"
#			end
#		end
#	end
#end

#def unzipper()
#	# helper function for unzip_sql
#	(-1..1).each do |i| 
#		(-1..1).each do |j| 
#			(-1..1).each do |k| 
#				(-1..1).each do |l|
#					puts Point4D.new(i, j, k, l)
#				end
#			end
#		end
#	end
#end

#unzipper()

def good_guess(possible)
	# generates a random volley of 10 and returns as array
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
	return volleys[ranks[0]][0]
end

# whovol = [
# Point4D.new(24, -64, 33, 62),
# Point4D.new(43, -64, 29, 63),
# Point4D.new(55, -66, 34, 59),
# Point4D.new(23, -62, 34, 64),
# Point4D.new(25, -67, 30, 62),
# Point4D.new(21, -64, 31, 60),
# Point4D.new(24, -63, 36, 60),
# Point4D.new(22, -63, 26, 62),
# Point4D.new(22, -61, 30, 65),
# Point4D.new(24, -65, 34, 56)]
	
possible = fr_sql('PL_X')

def build_volley(guess)
	# takes array of 10 Points and outputs 3 Volleys and a Point
	result = []
	pt_temp = []
	(0..8).each do |i|
		pt_temp.push(guess[i])
		if i % 3 == 2
			result.push(Volley.new(*pt_temp))
			pt_temp = []
		end
	end
	return result.push(guess[9])
end

guess = good_guess(possible)
vols = build_volley(guess)
(0..3).each do |x| 
	puts possible.length
	if x == 3
		possible = vols[x].status_check(possible, "N") 
	else
		possible = vols[x].status_check(possible, "NNN") 
	end
end
puts possible.length