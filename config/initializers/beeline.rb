Honeycomb.configure do |config|
  config.write_key = ENV['HONEYCOMB_WRITEKEY']
  config.dataset = 'pgbouncer_test'
end
