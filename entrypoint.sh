#!/bin/bash
# Start the server

#nginx -g 'daemon off;' THIS WILL STOP SCRIPT AT THIS LINE

service nginx stop
service nginx start
cd /app
RAILS_ENV=production bundle exec puma -C /app/config/puma.rb
/bin/bash
