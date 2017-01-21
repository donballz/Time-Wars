require_relative 'Point4D.rb'

# use full-miss sets to further limit possibility sphere
# broken into three sets because of a hunch about improved run time.

Miss1 = [   Point4D.new(5, 5, 5, 5),
			Point4D.new(-10, -10, -10, -10),
			Point4D.new(20, -20, 20, -20),
			Point4D.new(45, 50, 45, 50),
			Point4D.new(-45, 50, -45, 50),
			Point4D.new(45, -50, 45, -50),
			Point4D.new(25, -30, 25, -20),
			Point4D.new(-25, 45, 25, -50),
			Point4D.new(-10, 60, 15, -70),
			Point4D.new(0, 0, 0, 0)]



Miss2 = [   Point4D.new(13, -32, -14, -14),
			Point4D.new(13, 13, -59, -14),
			Point4D.new(13, 13, -89, -14),
			Point4D.new(58, 58, -14, -14),
			Point4D.new(58, 58, -14, 25),
			Point4D.new(58, 58, -14, 45),
			Point4D.new(58, 58, -40, 40),
			Point4D.new(10, 55, 30, 50),
			Point4D.new(0, -50, 5, -50),
			Point4D.new(33, -25, 64, 0),
			Point4D.new(0, 1, 99, 1),
			Point4D.new(5, 33, 21, 0),
			Point4D.new(1, 2, 3, 4),
			Point4D.new(-5, -15, -20, -30),
			Point4D.new(50, 20, 45, 50),
			Point4D.new(0, -10, 20, -30),
			Point4D.new(-10, 10, -10, 10),
			Point4D.new(-40, -25, 10, 10),
			Point4D.new(-20, -25, 10, 10),
			Point4D.new(20, -25, 10, 10),
			Point4D.new(40, -25, 10, 10),
			Point4D.new(-40, 25, 10, 10),
			Point4D.new(-20, 25, 10, 10)]




Miss3 = [   Point4D.new(5, -9, -70, 3),
			Point4D.new(-1, 44, -65, -42),
			Point4D.new(40, -30, 42, -73),
			Point4D.new(-36, 32, 79, -12),
			Point4D.new(-3, -4, 80, -32),
			Point4D.new(-52, -43, -40, 20),
			Point4D.new(-24, -24, -49, 42),
			Point4D.new(-72, -17, 0, -27),
			Point4D.new(-45, 76, 23, -19),
			Point4D.new(-9, -4, -34, 4),
			Point4D.new(15, 62, -50, 42),
			Point4D.new(50, 50, 50, 50),
			Point4D.new(-25, 17, 33, 2),
			Point4D.new(37, 5, 68, 20),
			Point4D.new(33, -18, 13, -1),
			Point4D.new(-46, -20, 2, -47),
			Point4D.new(-42, -65, 9, 20),
			Point4D.new(6, -45, 30, 72),
			Point4D.new(-17, 45, 13, -67),
			Point4D.new(-66, 39, 6, -56),
			Point4D.new(-3, -68, 21, 37),
			Point4D.new(63, 39, -31, 0),
			Point4D.new(-3, 2, -79, -15),
			Point4D.new(-54, -37, -11, 46),
			Point4D.new(59, 24, 27, 42),
			Point4D.new(-29, -48, -34, 48),
			Point4D.new(31, -8, -63, -41),
			Point4D.new(-26, 29, 72, -4),
			Point4D.new(41, -30, 52, 38),
			Point4D.new(62, -40, -34, 12),
			Point4D.new(60, 0, 0, 0),
			Point4D.new(-60, 0, 0, 0),
			Point4D.new(0, 60, 0, 0),
			Point4D.new(0, -60, 0, 0),
			Point4D.new(0, 0, 60, 0),
			Point4D.new(0, 0, -60, 0),
			Point4D.new(0, 0, 0, 60),
			Point4D.new(0, 0, 0, -60),
			Point4D.new(50, -50, 50, -50),
			Point4D.new(0, 0, 0, 0),
			Point4D.new(0, 0, 0, 0),
			Point4D.new(0, 22, 59, -77),
			Point4D.new(0, -77, 51, -38),
			Point4D.new(0, -21, -52, 79),
			Point4D.new(0, 51, -21, 1),
			Point4D.new(0, 18, 34, -66),
			Point4D.new(0, -33, 34, -35),
			Point4D.new(0, -18, -91, 0),
			Point4D.new(0, 28, -8, 70),
			Point4D.new(0, 7, 9, -99),
			Point4D.new(69, 69, 6, 6),
			Point4D.new(-69, -69, 6, 6),
			Point4D.new(1, 1, 2, 3),
			Point4D.new(10, 10, 20, 30),
			Point4D.new(-10, -10, -20, -30),
			Point4D.new(-20, 30, -40, 50),
			Point4D.new(-12, -36, 48, 5),
			Point4D.new(30, 30, -30, 0),
			Point4D.new(50, 50, -50, -50),
			Point4D.new(8, 67, 53, 9),
			Point4D.new(95, 0, 0, 0),
			Point4D.new(-95, 0, 0, 0),
			Point4D.new(0, 95, 0, 0),
			Point4D.new(0, -95, 0, 0),
			Point4D.new(0, 0, 95, 0),
			Point4D.new(0, 0, -95, 0),
			Point4D.new(0, 0, 0, 95),
			Point4D.new(0, 0, 0, -95),
			Point4D.new(42, 42, 42, 42),
			Point4D.new(8, 67, -53, 9)]

def Main()
	elducky1 = Point4D.new(30,10,30,10)
	possible = elducky1.within(30, 10)
	Miss1.each {|pt| possible = pt.without(possible, 30)}
	Miss2.each {|pt| possible = pt.without(possible, 30)}
	Miss3.each {|pt| possible = pt.without(possible, 30)}
	
	points = possible.length
	
	(0...20).each do |i|
	
		# sample of 10, within 10 and 3
		sample, nm, hit = get_volley(possible, 10, 10, 3) 
	
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