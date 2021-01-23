Rails.application.routes.draw do
  get '/ping', to: 'ping#handle'
end
