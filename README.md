## Virgo4 Basic API Testing

#### To run the tests:
1. Run `source export.bash`
2. Choose one of following commands:
    
    Functional test: `URL=$FUNCTIONAL_TEST_URL make functional-test`
    
    Catalog pool test: `URL=$CATALOG_POOL_URL make test-pool-catalog`
    
    JMRL pool test: `URL=$JMRL_POOL_URL make test-pool-jmrl`
    
    Articles pool test: `URL=$ARTICLES_POOL_URL make test-pool-articles`
    