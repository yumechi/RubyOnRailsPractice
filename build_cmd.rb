require 'optparse'
require 'json'

option = {}
OptionParser.new do |opt|
  opt.on('-d dirname', 'input deploy target dirname') {|v| option[:f] = v}

  opt.parse!(ARGV)
end

if option[:f]
  dir_name = option[:f]
  map_data = Hash.new
  File.open('map_data.json') do |j|
    map_data = JSON.load(j)
  end
  site_name = map_data[dir_name]
  if site_name
    puts "try build #{dir_name}"
    result = `git subtree push --prefix #{dir_name}/ heroku master`
    if $? == 0
      puts "show page: https://#{site_name}.herokuapp.com/"
    else
      puts "Error, #{$?}"
    end
  else
    puts "Error: not found #{dir_name}"
  end
end

