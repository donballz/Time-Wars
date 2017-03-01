require_relative 'common_funcs.rb'
require_relative 'Point4D.rb'
require_relative 'sql_store.rb'

def hash_template()
	# creates hash of numbers in increments of ten initialized to zero
	result = Hash.new()
	(-RADIUS..RADIUS).step(10) { |n| result[n] = 0 }
	return result
end

def heat_data(planet)
	# gets data from sql and creates map data: count of points in range
	xs = hash_template()
	ys = hash_template()
	zs = hash_template()
	ts = hash_template()
	if exists(planet)
		possible = fr_sql(planet) 
	else
		puts "no table found"
		return nil
	end
	possible.each do |pt|
		# x / 10 * 10 exploits non-float arithmetic to round down to nearest ten
		xs[pt.x / 10 * 10] += 1
		ys[pt.y / 10 * 10] += 1
		zs[pt.z / 10 * 10] += 1
		ts[pt.t / 10 * 10] += 1
	end
	return [xs, ys, zs, ts], possible.length.to_f
end

def heat_map(planet)
	# outputs formatted data
	heat, t = heat_data(planet)
	mets = [0.0]*4
	puts "Planet: #{planet}, Points possible: #{t.to_i}"
	(-RADIUS..RADIUS).step(10) do |n|
		s = "#{n}: "
		(0..3).each do |i| 
			mets[i] = heat[i][n] / t * 100.0 
			s += "#{mets[i].round(2)} " 
		end
		puts s
	end
end

heat_map('MAGA')