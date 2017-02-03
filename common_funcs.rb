require 'yaml'

PATH = '/Users/donald/Dropbox/Time Wars/yaml/'
EXCL = '/Users/donald/Dropbox/Time Wars/excel/'

def write(obj, fname)
	# writes any object to supplied filename. naming conflict with rT class func
	File.open(PATH + "#{fname}.yml", 'w') { |f| f.write obj.to_yaml }
end

def read(fname)
	# reads yaml file to object
	return YAML.load_file(PATH + "#{fname}.yml")
end
