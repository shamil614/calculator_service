require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/base'
require 'byebug'
require 'json'
require './calculator'

configure { set :server, :puma }

# HTTP based web service. Altnerative testbed to AMQP service
class HTTPService < Sinatra::Base
	post "/add" do
		values = params["values"].collect(&:to_i)
		res = Calculator.add_numbers(*values)
		content_type :json
		{ result: res }.to_json
	end
end


run HTTPService
