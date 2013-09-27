#! /bin/bash

#rm Gemfile.lock
bundle install > bundle.txt
RAILS_ENV=production bundle exec rake db:create > db_create.txt
RAILS_ENV=production bundle exec rake db:migrate > db_migrate.txt
#RAILS_ENV=production bundle exec rake assets:precompile
#rails g rename:app_to $1 > rename.txt
