require 'rubygems'
require 'bundler/setup'
require 'bunny'
require 'json'
require 'active_support/all'
require './calculator_producer'
require './calculator'
require 'byebug'

$bunny = Bunny.new
$bunny.start

$default_channel = $bunny.create_channel

at_exit do
	puts "Service is exiting"
end

begin
	service = CalculatorRpcProducer.new(method_receiver: Calculator, block: ARGV[0] || false)
	service.start
rescue Interrupt => _
	service.channel.close
	service.conneciton.close
end
