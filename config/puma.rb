threads 10, 10
workers 0

port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart
