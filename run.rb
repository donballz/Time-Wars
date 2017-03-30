require_relative 'Point4D.rb'
require_relative 'common_funcs.rb'
require_relative 'sql_store.rb'

def Main()
	elducky1 = Point4D.new(30,10,30,10)
	elducky2 = Point4D.new(40,20,36,8)
	elducky3 = Point4D.new(32,32,36,4)
	elducky4 = Point4D.new(36,20,36,8)
	elducky5 = Point4D.new(40,12,36,4)
	
	within1 = elducky1.within(30, 10)
	within2 = elducky2.within_set(within1, 30, 10)
	within3 = elducky3.within_set(within2, 30, 10)
	within4 = elducky4.within_set(within3, 30, 10)
	within5 = elducky5.within_set(within4, 30, 10)
	points = within5.length
	
	(0...20).each do |i|
	
		# sample of 10, within 10 and 3
		sample, nm, hit = get_volley(within5, 10, 10, 3) 
	
		#write(within30_10, 'elducky_possible')
		puts sample
		puts "#{(100*nm).round(2)}% points in near miss range"
		puts "#{(100*hit).round(2)}% points in hit range"
		puts "out of #{points} total points"
	end
end

def quick()
	(0..3).each do |n|
		(0..3).each do |g|
			(0..3).each do |x|
				puts ('N' * n) + ('G' * g) + ('X' * x) if n + g + x == 3
			end
		end
	end
end

def examine_volley(possible, volley)
	# generates random volleys and checks against coverage of possible space for planet
	metrics = get_volley_def(possible, volley, [GB, NM, HT])
	puts volley
	puts "#{(100*metrics[0]).round(2)}% points in glancing blow range"
	puts "#{(100*metrics[1]).round(2)}% points in near miss range"
	puts "#{(100*metrics[2]).round(2)}% points in hit range"
	puts "out of #{possible.length} total points"
end

def smartbomb_optimization(possible)
	# attempts to find best position for smart bomb
	best = Point4D.new(0,0,0,0)
	best_cnt = 0
	possible.each do |test_pt|
		cnt = 0
		possible.each { |pt| cnt +=1 if test_pt.dist(pt) <= GB + SB }
		if cnt > best_cnt
			best = test_pt 
			best_cnt = cnt 
		end
	end
	return best, best_cnt
end

now = Time.now
#Main()
#quick()
arac_r6 = [
			Point4D.new(-71, 33, 26, -20),
			Point4D.new(-75, 40, 21, -10),
			Point4D.new(-64, 30, 18, -20),
			Point4D.new(-78, 29, 5, -15),
			Point4D.new(-73, 33, 10, -6),
			Point4D.new(-70, 26, 12, -19),
			Point4D.new(-76, 24, 13, -21),
			Point4D.new(-73, 25, 4, -20),
			Point4D.new(-75, 35, 14, -11),
			Point4D.new(-71, 33, 20, -14)]
possible = fr_sql('PL_9')
best, best_cnt = smartbomb_optimization(possible)
puts best
puts "#{(100.0*best_cnt/possbile.length).round(2)}% points in glancing blow range"
puts "Run time: #{Time.now - now}"