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

puts exists('MAGA')
puts exists('DWHO')
puts exists('ZERO')