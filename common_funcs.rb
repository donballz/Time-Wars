require 'yaml'
require_relative 'CONSTANTS.rb'

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

