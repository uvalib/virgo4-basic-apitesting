.PHONY: test

test:
	rspec tests/test-*.rb

pool:
	rspec tests/test-pool-*.rb

master:
	rspec tests/test-master-*.rb
