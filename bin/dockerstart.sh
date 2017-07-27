#!/bin/bash

echo 'Migrate database start'
rake db:migrate
echo 'Migrated'
bundle exec puma -t 5:5 -p 3000 -e development
