require "optparse"
require "json"

def exec_command(cmd, pre_message = nil, post_message = nil)
  def puts_message(msg)
    if msg
      print "\e[33m"
      puts msg
      print "\e[0m"
    end
  end

  puts_message(pre_message)
  result = %x( #{cmd} )
  if $? != 0
    print "\e[31m"
    puts "Error, #{$?}"
    print "\e[0m"
    raise
  end
  puts_message(post_message)
end

option = {}
OptionParser.new do |opt|
  opt.on("-d dirname", "input deploy target dirname") { |v| option[:d] = v }
  opt.on("-f", "force deplhy target dirname") { |v| option[:f] = v }
  opt.on("-M", "not maint mode(default:on)") { |v| option[:M] = v }
  opt.on("-m", "not migrate(default:on)") { |v| option[:m] = v }

  opt.parse!(ARGV)
end

if option[:d]
  dir_name = option[:d]
  force_flag = option[:f]
  maint_flag = option[:M]
  migrate_flag = option[:m]
  map_data = Hash.new
  File.open("map_data.json") do |j|
    map_data = JSON.load(j)
  end
  site_name = map_data[dir_name]
  if force_flag or site_name
    exec_command("heroku maintenance:on", "maintenance on") if not maint_flag
    r = exec_command("git push heroku \`git subtree split --prefix #{dir_name} master\`:master --force",
                     "try build #{dir_name}",
                     site_name ? "show page: https://#{site_name}.herokuapp.com/" : "build success")
    exec_command("heroku run rails db:migrate", "migrate!") if not migrate_flag
    exec_command("heroku maintenance:off", "maintenance off") if not maint_flag
  else
    puts "Error: not found #{dir_name}"
  end
end
