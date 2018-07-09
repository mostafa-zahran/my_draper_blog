require 'yaml'

begin
  yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'application.yml'))).result)
  yaml_data.each {|key, value| ENV[key] = value}
rescue
  p 'application.yml not found'
end