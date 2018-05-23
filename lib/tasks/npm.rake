# frozen_string_literal: true

require 'json'
require 'English'

# Wrap the npm commands in package.json/scripts
# in their own namespaced tasks
namespace :npm do
  package_json = JSON.parse(File.read('package.json'))

  package_json['scripts'].each_key do |name|
    desc "#{name} from package.json/scripts"
    task(name) do
      unless system("npm run #{name}")
        STDERR.puts "npm run #{name} failed with exit code #{$CHILD_STATUS.exitstatus}"
        exit($CHILD_STATUS.exitstatus)
      end
    end
  end
end
