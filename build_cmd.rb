require 'optparse'
require 'json'

option = {}
OptionParser.new do |opt|
  opt.on('-d dirname', 'input deploy target dirname') {|v| option[:d] = v}
  opt.on('-f', 'force deplhy target dirname') {|v| option[:f] = v}

  opt.parse!(ARGV)
end

if option[:d]
  dir_name = option[:d]
  force_flag = option[:f]
  map_data = Hash.new
  File.open('map_data.json') do |j|
    map_data = JSON.load(j)
  end
  site_name = map_data[dir_name]
  if force_flag or site_name
    puts "try build #{dir_name}"
    result = `git subtree push --prefix #{dir_name}/ heroku master`
    if $? == 0
      puts site_name ? "show page: https://#{site_name}.herokuapp.com/" : "build success"
    else
      puts "Error, #{$?}"
    end
  else
    puts "Error: not found #{dir_name}"
  end
end

