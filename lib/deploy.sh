#! /bin/bash

cd /www/$1
echo '1'
rm Gemfile.lock
bundle install > bundle.txt
echo 'After bundle'
RAILS_ENV=production bundle exec rake db:create > db_create.txt
echo 'after create'
RAILS_ENV=production bundle exec rake db:migrate > db_migrate.txt
echo 'after migrate'
#RAILS_ENV=production bundle exec rake assets:precompile
#rails g rename:app_to $1 > rename.txt
