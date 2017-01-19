require_relative 'common_funcs.rb'

def universe
	# returns every possible point in 100-radius hypersphere
	r = 100
	(-r..r).each do |i| 
		(-r..r).each do |j| 
			(-r..r).each do |k| 
				(-r..r).each do |l|
					if i**2 + j**2 + k**2 + l**2  <= r**2  
						yield Point4D.new(i, j, k, l)
					end
				end
			end
		end
	end
end

class Point4D
	ATTRS = [:x, :y, :z, :t]
	attr_reader(*ATTRS)
		
	def initialize(x, y, z, t)
		@x = x
		@y = y
		@z = z
		@t = t
	end
	
	def to_s
		# string representation of a point
		return "(#{@x}, #{@y}, #{@z}, #{@t})"
	end
	
	def dist(pt2)
		# gives distance between any two points
		((@x - pt2.x)**2 + (@y - pt2.y)**2 + (@z - pt2.z)**2 + (@t - pt2.t)**2)**0.5
	end

	def within(range, wo=0)
		# return list of points within a range
		result = []
		universe {|pt| result.push(pt) if pt.dist(self) <= range and pt.dist(self) >= wo}
		return result
	end
end

def Main()
	elducky = Point4D.new(30,10,30,10)
	within30_10 = elducky.within(30, 10)
	points = within30_10.length
	write(within30_10, 'elducky_possible')
	puts within30_10
	puts points
end

now = Time.now
Main()
puts "Run time: #{Time.now - now}"