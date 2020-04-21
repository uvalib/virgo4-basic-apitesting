.PHONY: test
all: functional-test test-pools test-master test-client
test-pools: test-pool-catalog test-pool-jmrl test-pool-articles

functional-test:
	rspec tests/functional-tests.rb

test-pool-catalog:
	rspec tests/test-pool-search.rb tests/individual-pool-search/test-books-pool.rb

test-pool-jmrl:
	rspec tests/test-pool-search.rb tests/individual-pool-search/test-jmrl-pool.rb

test-pool-articles:
	rspec tests/test-pool-search.rb tests/individual-pool-search/test-articles-pool.rb

test-master:
	rspec tests/test-master-*.rb

test-client:
	rspec tests/test-search-client.rb
