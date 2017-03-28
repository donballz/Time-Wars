require 'yaml'
require_relative 'CONSTANTS.rb'

def write(obj, fname)
	# writes any object to supplied filename. naming conflict with rT class func
	File.open(PATH + "#{fname}.yml", 'w') { |f| f.write obj.to_yaml }
end

def read(fname)
	# reads yaml file to object
	return YAML.load_file(PATH + "#{fname}.yml")
end

class Fixnum
	def sign
		return -1 if self < 0
		return 1
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

