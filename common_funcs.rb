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

def unzipper()
	# helper function for unzip_sql
	(-1..1).each do |i| 
		(-1..1).each do |j| 
			(-1..1).each do |k| 
				(-1..1).each do |l|
					yield Point4D.new(i, j, k, l)
				end
			end
		end
	end
end

def unzip_sql(table)
	# takes table of "zipped" (even only) points and generates full list of points
	possible = []
	zipped = fr_sql(table)
	zipped.each do |z|
		unzipper { |u| possible.push(z + u) }
	end
	return possible
end