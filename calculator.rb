class Calculator
	# consumer knows to call this method via documentation
	# made the method name kinda odd...just cuz
	# numbers [Integers] any number of arguments
	def self.add_numbers(*numbers)
		numbers.inject(&:+)
	end
end
