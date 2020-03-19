.PHONY: test
all: test-pools test-master test-client
test-pools: test-pool-catalog test-pool-jmrl test-pool-articles

test-pool-catalog:
	URL='https://pool-solr-ws-catalog.internal.lib.virginia.edu' rspec tests/test-pool-search/test-books-pool.rb

test-pool-jmrl:
	URL='https://pool-jmrl-ws.internal.lib.virginia.edu' rspec tests/test-pool-search/test-jmrl-pool.rb
	#URL='https://pool-jmrl-ws-dev.internal.lib.virginia.edu' rspec tests/test-pool-search/test-jmrl-pool.rb

test-pool-articles:
	URL='https://pool-eds-ws.internal.lib.virginia.edu' rspec tests/test-pool-search/test-articles-pool.rb

test-master:
	rspec tests/test-master-*.rb

test-client:
	rspec tests/test-search-client.rb
