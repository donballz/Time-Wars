require 'mysql'
require 'yaml'
require_relative 'CONSTANTS.rb'
require_relative 'Point4D.rb'
require_relative 'hunt_dwho.rb'

# SQL Code to create the template
#USE time;
#DROP TABLE IF EXISTS template;

#CREATE TABLE IF NOT EXISTS template (
#X INT,
#Y INT,
#Z INT,
#T INT);

def to_sql(pt_set, table)
	# drops table and uploads set to table name
	begin
		con = Mysql.new SRVR, USER, PSWD
		con.query("USE #{SCMA}")
		con.query("DROP TABLE IF EXISTS #{table}")
		con.query("CREATE TABLE #{table} AS SELECT * FROM TEMPLATE")
		pt_set.each do |pt|
			con.query("INSERT INTO #{table}
						SELECT #{pt.x}, #{pt.y}, #{pt.z}, #{pt.t} FROM DUAL")
		end
		
	rescue Mysql::Error => e
		puts e.errno
		puts e.error

	ensure
		con.close if con
	end
end

def fr_sql(table)
	# reads data from sql table and outputs list of 4D points
	output = []
	begin
		con = Mysql.new SRVR, USER, PSWD
		con.query("USE #{SCMA}")
		rows = con.query("SELECT * FROM #{table}")
		rows.each_hash do |row|
			output.push(Point4D.new(row['X'], row['Y'], row['Z'], row['T']))
		end
		
	rescue Mysql::Error => e
		puts e.errno
		puts e.error

	ensure
		con.close if con
	end
	return output
end

def Testing()
	#misses = planet_data(PLANET, 'X')
	#to_sql(misses, PLANET)
	misses = fr_sql(PLANET)
	misses.each { |m| puts m }
	puts misses.length
end

now = Time.now
Testing()
puts "Run time: #{Time.now - now}"