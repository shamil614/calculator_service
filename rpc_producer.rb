# Maybe a foundation for RPC Producers across apps.  Perhaps we can stuff it into a gem???

class RpcProducer
	attr_reader :connection, :channel, :queue
	# method_reciver => object that receives the method. can be a class or anything responding to send
	def initialize(connection: $bunny, channel: $default_channel, queue_name: nil, method_receiver: , block: false)
		# create a channel and exchange that both client and server know about
		@connection = connection
		@channel = channel
		@queue_name = queue_name || self.class.to_s.gsub('Producer','')
		@block = block
		@method_receiver = method_receiver
	end

	def start
		@queue = @channel.queue(@queue_name || self.class.to_s.gsub('Producer', ''))
		@exchange  = @channel.default_exchange

		# subscribe is like a callback
		puts "Listening for messages on #{@queue.name}"
		@queue.subscribe(block: @block) do |delivery_info, properties, payload|
			puts "Receiving message: #{payload}"
			request_message = JSON.parse(payload).with_indifferent_access
			result = @method_receiver.send(request_message[:method], *request_message[:params])
			reply(request_message: request_message, result: result, properties: properties)
		end
	end

	private
	def reply(request_message:, result:, properties:)
	  response_message = { id: request_message[:id], result: result, json_rpc: '2.0' }
		puts "Publishing result: #{result} to #{response_message}"
		@exchange.publish(response_message.to_json, routing_key: properties.reply_to,
											correlation_id: properties.correlation_id)
	end

end
