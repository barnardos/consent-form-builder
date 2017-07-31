require 'json'

# Wrap the npm commands in package.json/scripts
# in their own namespaced tasks
namespace :npm do
  package_json = JSON.parse(File.read('package.json'))

  package_json['scripts'].each do |name, _command|
    desc "#{name} from package.json/scripts"
    task(name) { puts `npm run #{name}` }
  end
end
