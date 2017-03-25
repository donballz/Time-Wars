require_relative 'common_funcs.rb'

RADIUS = 100

def universe(step=1)
	# returns every possible point in 100-radius hypersphere
	r = RADIUS
	(-r..r).step(step) do |i| 
		(-r..r).step(step) do |j| 
			(-r..r).step(step) do |k| 
				(-r..r).step(step) do |l|
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
	
	def +(pt)
		# adds two points together
		return Point4D.new(self.x + pt.x, self.y + pt.y, self.z + pt.z, self.t + pt.t)
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

def get_volley(set, n, lim_set)
	# creates random sample of size n and checks it against the set's points
	# returns the sample and the percentage of points in the set it hits in an array
	sample = set.sample(n)
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

def get_volley_def(set, sample, lim_set)
	# checks given sample and checks it against the set's points
	# returns the percentage of points in the set it hits in an array
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
	return lim_pts.map { |l| l / total_pts }
end


class Volley 
	# class to hold set of three points so each data point of this type can be considered in total
	ATTRS = [:x, :y, :z, :t]
	attr_reader(*ATTRS)
		
	def initialize(one, two, thr)
		@one = one
		@two = two
		@thr = thr
		@set = [one, two, thr]
	end
	
	def to_s
		# string representation of a point set
		return @one.to_s + "\n" + @two.to_s + "\n" + @thr.to_s
	end
	
	def each
		# allows user to iterate over the point set
		@set.each { |s| yield s }
	end
	
	def dist(pt)
		# gives distance report between any two from set to given pt
		hits, nears, glances, misses = 0, 0, 0, 0
		@set.each do |point|
			dist = point.dist(pt)
			if dist <= HT
				hits += 1
			elsif dist <= NM
				nears += 1
			elsif dist <= GB
				glances += 1
			else
				misses += 1
			end
		end
		return ('H' * hits) + ('N' * nears) + ('G' * glances) + ('X' * misses)
	end
end

