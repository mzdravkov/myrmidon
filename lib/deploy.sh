#! /bin/bash

cd /var/www-data/$1
bundle install > /tmp/bundle.txt
RAILS_ENV=production bundle exec rake db:create > /tmp/db_c.txt
RAILS_ENV=production bundle exec rake db:migrate > /tmp/db_m.txt
#RAILS_ENV=production bundle exec rake assets:precompile
#rails g rename:app_to $1
