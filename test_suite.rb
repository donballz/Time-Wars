require 'test/unit'
require 'yaml'
require_relative 'Point4D.rb'

# Tests to include. 
 
class BBModelTestSuite < Test::Unit::TestCase

	Linked = [	Point4D.new(10, 20, 30, 40),	
				Point4D.new(10, 20, 30, 41),	
				Point4D.new(10, 20, 30, 42),	
				Point4D.new(10, 20, 30, 43),	
				Point4D.new(10, 20, 30, 44),	
				Point4D.new(10, 20, 30, 45),	
				Point4D.new(10, 20, 30, 46),	
				Point4D.new(10, 20, 30, 47),	
				Point4D.new(10, 20, 30, 48),	
				Point4D.new(10, 20, 30, 49),	
				Point4D.new(10, 20, 30, 50),	
				Point4D.new(10, 20, 30, 51),	
				Point4D.new(10, 20, 30, 52),	
				Point4D.new(10, 20, 30, 53),	
				Point4D.new(10, 20, 30, 54),	
				Point4D.new(10, 20, 30, 55),	
				Point4D.new(10, 20, 30, 56),	
				Point4D.new(10, 20, 30, 57),	
				Point4D.new(10, 20, 30, 58),	
				Point4D.new(10, 20, 30, 59)]
				
	Sample = [	Point4D.new(-16, 55, 82, 19),	
				Point4D.new(-17, -95, -45, -31),	
				Point4D.new(-20, 37, 6, 8),	
				Point4D.new(76, 73, -90, -11),	
				Point4D.new(-50, -49, -83, -70),	
				Point4D.new(-71, -34, 48, 63),	
				Point4D.new(49, -12, -98, 7),	
				Point4D.new(-60, 76, -48, -37),	
				Point4D.new(53, -78, 10, -3),	
				Point4D.new(24, 58, -14, -98),	
				Point4D.new(-56, -37, 76, -28),	
				Point4D.new(-36, 4, 11, 18),	
				Point4D.new(-8, 13, -51, -8),	
				Point4D.new(-63, 90, 5, 28),	
				Point4D.new(-7, 9, 71, -74),	
				Point4D.new(-8, 71, -25, 53),	
				Point4D.new(33, 87, -32, 29),	
				Point4D.new(94, -25, 59, -30),	
				Point4D.new(-5, 76, 47, 27),	
				Point4D.new(35, 4, 81, -100)]
	
	def test_get_volley
		#assert_equal(Array, tables.class, "tables not loaded")
		sample, win0, win20 = get_volley(Linked, 5, 0, 20)
		assert_equal(5.0/Linked.length, win0, "Should be exactly one point matching at zero for each in set")
		assert_equal(1, win20, "All points should be within 20")
	end
	
end