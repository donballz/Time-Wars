require_relative 'common_funcs.rb'

RADIUS = 100

def universe
	# returns every possible point in 100-radius hypersphere
	r = RADIUS
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
	
	def ==(pt)
		# equivalence test
		@x == pt.x and @y == pt.y and @z == pt.z and @t == pt.t
	end
	
	def dist(pt2)
		# gives distance between any two points
		((@x - pt2.x)**2 + (@y - pt2.y)**2 + (@z - pt2.z)**2 + (@t - pt2.t)**2)**0.5
	end

	def within(range, wo=0)
		# return list of points within a range from entire hypersphere
		result = []
		universe {|pt| result.push(pt) if pt.dist(self) <= range and pt.dist(self) >= wo}
		return result
	end
	
	def within_set(set, range, wo=0)
		# return list of points within a range from given set of points
		result = []
		set.each {|pt| result.push(pt) if pt.dist(self) <= range and pt.dist(self) >= wo}
		return result
	end
	
	def without_set(set, range)
		# return list of points which fully miss the shot by distance equal to range
		result = []
		set.each {|pt| result.push(pt) if pt.dist(self) > range}
		return result
	end
	
	def point_set(range)
		# returns set of points within range of given point
		result = []
		(self.x - range..self.x + range).each do |i|
			(self.y - range..self.y + range).each do |j| 
				(self.z - range..self.z + range).each do |k| 
					(self.t - range..self.t + range).each do |l|
						try = Point4D.new(i,j,k,l)
						result.push(try) if self.dist(try) <= range and i**2 + j**2 + k**2 + l**2  <= RADIUS**2
					end
				end
			end
		end
		return result
	end
end

def get_volley(set, n, lim1, lim2)
	# creates random sample of size n and checks it against the set's points
	# returns the sample and the percentage of points in the set it hits
	sample = set.sample(n)
	total_pts, lim1_pts, lim2_pts = 0.0, 0, 0
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
	return sample, lim1_pts / total_pts, lim2_pts / total_pts
end

def get_volley2(set, n, lim1, lim2)
	# selects single point randomly and eliminates points within lim1 
	# before selecting another point to create sample of size n 
	# and check it against the set's other points
	# returns the sample and the percentage of points in the set it hits
	####### Takes 5 minutes longer and offers zero improvement
	copy = set.clone
	sample = []
	(1..n).each do |i|
		single = set.sample(1)
		set = single[0].without_set(set, lim1)
		sample.push(single[0])
	end
	total_pts, lim1_pts, lim2_pts = 0.0, 0, 0
	copy.each do |pt|
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
	return sample, lim1_pts / total_pts, lim2_pts / total_pts
end

# Try: choose random set check percentage of points in elducky's glancing blow
# 	   land within 10 and 30 of the set members. Repeat this 10-20 times and 
# 	   choose the best option.

