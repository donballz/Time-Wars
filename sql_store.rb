require 'mysql'
require 'yaml'
require_relative 'CONSTANTS.rb'
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
						SELECT #{pt.X}, #{pt.Y}, #{pt.Z}, #{pt.T} FROM DUAL")
		end
		
	rescue Mysql::Error => e
		puts e.errno
		puts e.error

	ensure
		con.close if con
	end
end

def Testing()
	misses = planet_data(PLANET, 'X')
	to_sql(misses, PLANET)
end

now = Time.now
Testing()
puts "Run time: #{Time.now - now}"