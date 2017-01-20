require_relative 'Point4D.rb'

def Main()
	elducky1 = Point4D.new(30,10,30,10)
	elducky2 = Point4D.new(40,20,36,8)
	elducky3 = Point4D.new(32,32,36,4)
	elducky4 = Point4D.new(36,20,36,8)
	elducky5 = Point4D.new(40,12,36,4)
	
	within1 = elducky1.within(30, 10)
	within2 = elducky2.within_set(within1, 30, 10)
	within3 = elducky2.within_set(within2, 30, 10)
	within4 = elducky2.within_set(within3, 30, 10)
	within5 = elducky2.within_set(within4, 30, 10)
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

now = Time.now
Main()
puts "Run time: #{Time.now - now}"