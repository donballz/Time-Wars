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
	
	def status(pt, sb=0)
		# returns letter status with from given point
		dist = pt.dist(self)
		if dist <= HT + sb
			return 'H'
		elsif dist <= NM + sb
			return 'N'
		elsif dist <= GB + sb
			return 'G'
		else
			return 'X'
		end
	end
	
	def status_check(set, status)
		# returns list of points which have a given letter status, for volley fours
		result = []
		set.each { |pt| result.push(pt) if pt.status(self) == status }
		return result
	end
	
	def without_status(set, status)
		# returns list of points which do NOT have a given letter status
		result = []
		set.each { |pt| result.push(pt) if pt.status(self) != status }
		return result
	end
	
	def smartbomb(set, status)
		# return list of points which have a given letter status, for smart bombs
		result = []
		set.each { |pt| result.push(pt) if pt.status(self, SB) == status }
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

class Volley 
	# class to hold set of three points so each data point of this type can be considered in total
	ATTRS = [:one, :two, :thr]
	attr_reader(*ATTRS)
		
	def initialize(one, two, thr)
		@one = one
		@two = two
		@thr = thr
	end
	
	def to_s
		# string representation of a point set
		return @one.to_s + "\n" + @two.to_s + "\n" + @thr.to_s
	end
	
	def each
		# allows user to iterate over the point set
		[@one, @two, @thr].each { |s| yield s }
	end
	
	def status(pt)
		# gives distance report between any two from set to given pt
		hits, nears, glances, misses = 0, 0, 0, 0
		self.each do |point|
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
	
	def status_check(set, status)
		# return list of points with a given distance status
		result = []
		set.each {|pt| result.push(pt) if self.status(pt) == status}
		return result
	end
end

