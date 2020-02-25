.PHONY: test
all: test-catalog test-jmrl test-article

test-catalog:
	URL='https://pool-solr-ws-catalog.internal.lib.virginia.edu' rspec tests/test-*.rb

test-jmrl:
	URL='https://pool-jmrl-ws.internal.lib.virginia.edu' rspec tests/test-*.rb

test-article:
	URL='https://pool-eds-ws.internal.lib.virginia.edu' rspec tests/test-*.rb

pool-catalog:
	URL='https://pool-jmrl-ws.internal.lib.virginia.edu' rspec tests/test-pool-*.rb

pool-jmrl:
    URL='https://pool-jmrl-ws.internal.lib.virginia.edu' rspec tests/test-pool-*.rb

pool-article:
	URL='https://pool-eds-ws.internal.lib.virginia.edu' rspec tests/test-pool-*.rb

master-catalog:
	URL='https://pool-jmrl-ws.internal.lib.virginia.edu' rspec tests/test-master-*.rb

master-jmrl:
    URL='https://pool-jmrl-ws.internal.lib.virginia.edu' rspec tests/test-master-*.rb

master-article:
	URL='https://pool-eds-ws.internal.lib.virginia.edu' rspec tests/test-master-*.rb