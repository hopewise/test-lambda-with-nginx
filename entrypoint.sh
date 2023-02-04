#!/bin/bash
# Start the server

#nginx -g 'daemon off;' THIS WILL STOP SCRIPT AT THIS LINE

service nginx stop
service nginx start
cd /app
python3 -m http.server 3000 --bind 127.0.0.1
#RAILS_ENV=production bundle exec puma -C /app/config/puma.rb
/bin/bash
