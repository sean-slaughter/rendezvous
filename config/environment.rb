ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])


require 'sinatra/base'
require 'rack-flash'
require 'pry'
require './app/controllers/application_controller'
require_all 'app'
