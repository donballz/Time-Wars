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

def unzipper()
	# helper function for unzip_sql
	(-1..1).each do |i| 
		(-1..1).each do |j| 
			(-1..1).each do |k| 
				(-1..1).each do |l|
					puts Point4D.new(i, j, k, l)
				end
			end
		end
	end
end

#unzipper()

whovol = [
Point4D.new(24, -64, 33, 62),
Point4D.new(23, -64, 29, 63),
Point4D.new(25, -66, 34, 59),
Point4D.new(23, -62, 34, 64),
Point4D.new(25, -67, 30, 62),
Point4D.new(21, -64, 31, 60),
Point4D.new(24, -63, 36, 60),
Point4D.new(22, -63, 26, 62),
Point4D.new(22, -61, 30, 65),
Point4D.new(24, -65, 34, 56)]
	
possible = fr_sql('PL_3')

def get_volley_def(set, sample, lim_set)
	# checks given sample and checks it against the set's points
	# returns the sample and the percentage of points in the set it hits in an array
	total_pts = 0.0
	m = lim_set.length
	lim_pts = [0] * m
	set.each do |pt|
		hits = [false] * m
		sample.each do |shot| 
			dist = shot.dist(pt)
			(0...m).each { |i| hits[i] = true if dist <= lim_set[i] }
		end
		(0...m).each { |i|  lim_pts[i] += 1 if hits[i] }
		total_pts += 1
	end
	return sample, lim_pts.map { |l| l / total_pts }
end

sample, metrics = get_volley_def(possible, whovol, 10, [30, 10, 3])
puts sample
puts "#{(100*metrics[0]).round(2)}% points in glancing blow range"
puts "#{(100*metrics[1]).round(2)}% points in near miss range"
puts "#{(100*metrics[2]).round(2)}% points in hit range"
puts "out of #{possible.length} total points"