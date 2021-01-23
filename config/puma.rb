web_threads = ENV.fetch("MAX_THREADS", 8).to_i
threads web_threads, web_threads

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

workers 0

plugin :tmp_restart
