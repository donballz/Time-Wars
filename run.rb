require_relative 'Point4D.rb'

def Main()
	elducky = Point4D.new(30,10,30,10)
	within30_10 = elducky.within(30, 10)
	points = within30_10.length
	
	# sample of 10, within 10 and 3
	sample, nm, hit = get_volley(within30_10, 10, 10, 3) 
	
	#write(within30_10, 'elducky_possible')
	puts sample
	puts "#{(100*nm).round(2)}% points in near miss range"
	puts "#{(100*hit).round(2)}% point in hit range"
	puts "out of #{points} total points"
end

now = Time.now
Main()
puts "Run time: #{Time.now - now}"