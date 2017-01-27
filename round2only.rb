require_relative 'Point4D.rb'

# use full-miss sets to further limit possibility sphere
# No value in separate miss sets

Miss1 = [   Point4D.new(5, 5, 5, 5),
			Point4D.new(-10, -10, -10, -10),
			Point4D.new(20, -20, 20, -20),
			Point4D.new(45, 50, 45, 50),
			Point4D.new(-45, 50, -45, 50),
			Point4D.new(45, -50, 45, -50),
			Point4D.new(25, -30, 25, -20),
			Point4D.new(-25, 45, 25, -50),
			Point4D.new(-10, 60, 15, -70),
			Point4D.new(0, 0, 0, 0),
			Point4D.new(13, -32, -14, -14),
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
			Point4D.new(-20, 25, 10, 10),
			Point4D.new(5, -9, -70, 3),
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

Miss2 = [	Point4D.new(20, 9, 15, 25),
			Point4D.new(-42, -65, 9, 20),
			Point4D.new(0, 28, -8, 70),
			Point4D.new(10, 28, -8, 70),
			Point4D.new(-17, 45, 13, -67),
			Point4D.new(15, 55, -21, 9),
			Point4D.new(5, -77, 51, -38),
			Point4D.new(0, -77, 51, -38),
			Point4D.new(-5, -77, 51, -38),
			Point4D.new(13, -21, -52, -44),
			Point4D.new(-14, -31, -29, 79),
			Point4D.new(-63, -52, -30, -37),
			Point4D.new(3, 73, -55, -19),
			Point4D.new(11, -4, 56, 20),
			Point4D.new(28, -14, 47, 4),
			Point4D.new(-39, -54, 32, 1),
			Point4D.new(-11, -35, -78, -11),
			Point4D.new(44, 29, 34, -33),
			Point4D.new(-58, -12, 50, 8),
			Point4D.new(-15, 26, 56, 47),
			Point4D.new(20, 12, -36, 67),
			Point4D.new(-29, -57, 11, 46),
			Point4D.new(62, 32, 10, -37),
			Point4D.new(-12, 71, -2, -35),
			Point4D.new(-61, 39, -36, -8),
			Point4D.new(25, 6, -28, -73),
			Point4D.new(-72, 1, 11, 39),
			Point4D.new(-42, -28, 14, 56),
			Point4D.new(0, 0, -70, -70),
			Point4D.new(42, 84, -14, 28),
			Point4D.new(-21, 63, -7, 7),
			Point4D.new(-14, 70, -7, 7),
			Point4D.new(7, 56, -14, -21),
			Point4D.new(5, 5, 95, 5),
			Point4D.new(88, 15, -40, 20),
			Point4D.new(73, -65, -7, -3),
			Point4D.new(18, 48, 2, 18),
			Point4D.new(8, 44, 15, 5),
			Point4D.new(0, 45, -21, 23),
			Point4D.new(-20, -67, -10, -39),
			Point4D.new(-41, -2, -19, 3),
			Point4D.new(24, -7, -37, -17),
			Point4D.new(20, 29, -39, 31),
			Point4D.new(-19, 75, 56, 69),
			Point4D.new(-11, 7, 52, -47),
			Point4D.new(10, 77, 41, 35),
			Point4D.new(10, 77, 51, 25),
			Point4D.new(-10, 67, 51, 35),
			Point4D.new(-10, 77, 41, 35),
			Point4D.new(-10, 77, 51, 25),
			Point4D.new(0, 67, 41, 35),
			Point4D.new(0, 67, 51, 25),
			Point4D.new(0, 77, 41, 25),
			Point4D.new(10, 67, 51, 35),
			Point4D.new(30, 30, -30, 30),
			Point4D.new(30, 30, 30, -30),
			Point4D.new(-30, -30, 30, 30),
			Point4D.new(0, 50, -10, 0),
			Point4D.new(-20, -20, 20, 10),
			Point4D.new(-30, -30, -30, 30),
			Point4D.new(4, 8, 15, 16),
			Point4D.new(23, 42, 4, 8),
			Point4D.new(15, 16, 23, 42),
			Point4D.new(-4, -8, -15, -16),
			Point4D.new(-23, -42, -4, -8),
			Point4D.new(-15, -16, -23, -42),
			Point4D.new(4, 8, -15, -16),
			Point4D.new(23, 42, -4, -8),
			Point4D.new(15, 16, -23, -42),
			Point4D.new(-8, -45, -70, 21),
			Point4D.new(-18, 4, 5, -63),
			Point4D.new(8, -64, -15, 41),
			Point4D.new(12, -56, 11, 14),
			Point4D.new(69, -40, 38, -34),
			Point4D.new(-51, 12, -17, 12),
			Point4D.new(-79, -25, 9, 15),
			Point4D.new(-16, 38, -4, 81),
			Point4D.new(9, 13, 49, 12)]

def Main()
	elducky1 = Point4D.new(30,10,30,10) # from round 1
	elducky2 = Point4D.new(20,15,25,10) # round 2, soyleche V4
	elducky3 = Point4D.new(28,7,26,25) # round 2, Doctor Who V2
	elducky4 = Point4D.new(38,7,26,17) # round 2, Doctor Who V2
	elducky5 = Point4D.new(32,15,34,1) # round 2, Doctor Who V2
	elducky6 = Point4D.new(18,17,26,29) # round 2, Doctor Who V4
	elducky7 = Point4D.new(40,20,36,8) # round 2, soyleche V4
	possible = elducky1.within(30, 10)
	puts "elducky1 #{possible.length}"
	possible = elducky2.within_set(possible, 30, 10)
	puts "elducky2 #{possible.length}"
	possible = elducky3.within_set(possible, 30, 10)
	puts "elducky3 #{possible.length}"
	possible = elducky4.within_set(possible, 30, 10)
	puts "elducky4 #{possible.length}"
	possible = elducky5.within_set(possible, 30, 10)
	puts "elducky5 #{possible.length}"
	possible = elducky6.within_set(possible, 30, 10)
	puts "elducky6 #{possible.length}"
	possible = elducky7.within_set(possible, 30, 10)
	puts "elducky7 #{possible.length}"
	Miss1.each {|pt| possible = pt.without_set(possible, 30)}
	Miss2.each {|pt| possible = pt.without_set(possible, 30)}
	
	points = possible.length
	
	(0...20).each do |i|
	
		# sample of 10, within 10 and 3
		sample, nm, hit = get_volley2(possible, 10, 10, 3) 
	
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