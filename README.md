# A simple calculation service
	There's two ways to run the service.  AMQP via bunny, or HTTP with Puma.

## Install
	Make sure to have AMQP installed via homebrew.  Install gems via bundler.

## Starting the AMQP based service
	In another terminal window
	run ``` ruby app.rb true ```
	The second argument is to run the service in a IO blocking fashion

## Starting web service
	cd into project directroy.
	```bash
	rackup
	```
	Puma should shart on ```localhost:9292```

## TODOs
	1. Switch to a command line tooling like Thor
	2. Figure out some sort of Logging solution
	3. Add tests
