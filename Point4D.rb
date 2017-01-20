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

def get_volley(set, n, lim1, lim2)
	# creates random sample of size n and checks it against the set's points
	# returns the sample and the percentage of points in the set it hits
	sample = set.sample(n)
	total_pts, lim1_pts, lim2_pts = 0, 0, 0
	set.each do |pt|
		hit1, hit2 = false, false
		sample.each do |shot| 
			dist = shot.dist(pt)
			hit1 = true if dist <= lim1
			hit2 = true if dist <= lim2
		end
		lim1_pts += 1 if hit1
		lim2_pts += 1 if hit2
		total_pts += 1
	end
end

# Try: choose random set check percentage of points in elducky's glancing blow
# 	   land within 10 and 30 of the set members. Repeat this 10-20 times and 
# 	   choose the best option.

def Main()
	elducky = Point4D.new(30,10,30,10)
	within30_10 = elducky.within(30, 10)
	points = within30_10.length
	#write(within30_10, 'elducky_possible')
	puts within30_10
	puts points
end

now = Time.now
Main()
puts "Run time: #{Time.now - now}"