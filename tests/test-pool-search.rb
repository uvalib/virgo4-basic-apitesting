#
# basic set of pool tests per: https://confluence.lib.virginia.edu/pages/viewpage.action?spaceKey=VIRGO4&title=Automated+Tests
#

require 'airborne'
require './tests/helpers'

describe 'pool' do

  # define the endpoints
  search_endpoint = '/api/search'
  facet_endpoint = '/api/search/facets'

  before do
    Airborne.configuration.base_url = 'https://pool-solr-ws-catalog-dev.internal.lib.virginia.edu'
    Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer bkb4notbo1bc80d2uucg' }
    Airborne.configuration.verify_ssl = false
  end

  #
  # tests that the search call returns reported JSON
  #
  it 'search should return json' do
    post search_endpoint, { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect(headers[:content_type]).to eq('application/json; charset=utf-8')
  end

  #
  # tests that the facet call returns reported JSON
  #
  it 'search should return json' do
    post facet_endpoint, { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect(headers[:content_type]).to eq('application/json; charset=utf-8')
  end

  #
  # tests that we have a reasonable structure in response to a search request
  #
  it 'should return the correct search response structure' do
     post search_endpoint, { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
     expect_status( 200 )

     expect_json_types( identity: :object)
     expect_json_types( pagination: :object)
     expect_json_types( group_list: :array_of_objects)
     #expect_json_types( available_facets: :array_of_objects)
     expect_json_types( confidence: :string)
     expect_json_types( elapsed_ms: :int)
     #puts json_body
     #puts body
     #puts headers
  end

  #
  # tests that we have a reasonable structure in response to a facet request
  #
  it 'should return the correct facet response structure' do
    post facet_endpoint, { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    #expect_json_types( identity: :object)
    #expect_json_types( pagination: :object)
    #expect_json_types( group_list: :array_of_objects)
    #expect_json_types( available_facets: :array_of_objects)
    #expect_json_types( confidence: :string)
    #expect_json_types( elapsed_ms: :int)
    #puts json_body
    #puts body
    #puts headers
  end

  #
  # test that a search returns at least 1 item
  #
  it 'should return one or more items' do
    post search_endpoint, { :query => "author:{*}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
  end

  #
  # test that a facet search returns at least 1 facet
  #
  it 'should return one or more facets' do
    post facet_endpoint, { :query => "author:{*}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:facet_list].count ).to be > 0
  end

  #
  # test that a multi-facet filter returns at least information about each facet
  #

  #
  # test that a facet filter returns the expected number of items
  #

  #
  # test that an invalid facet filter returns the correct response
  #

  #
  # test that a multi-word known title search returns an item with that known title first
  #
  it 'should return exact title match' do
    post search_endpoint, { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0

    # extract the first title from the results
    first_title = Helpers.pool_results_first_title( json_body )
    #puts first_title

    # search for all items with this title
    post search_endpoint, { :query => "title:{\"#{first_title}\"}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
    all_titles = Helpers.pool_results_all_titles( json_body )
    #puts all_titles

    expect(all_titles[0]).to eq(first_title)

  end

  #
  # test that a subject search returns items with the identical subject
  #
  it 'should return exact subject match' do
    post search_endpoint, { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0

    # extract the first subject from the results
    first_subject = Helpers.pool_results_first_subject( json_body )
    #puts first_subject

    # search for all items with this subject
    post search_endpoint, { :query => "subject:{\"#{first_subject}\"}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
    all_subjects = Helpers.pool_results_all_subjects( json_body )
    #puts all_subjects

    expect(all_subjects).to include(first_subject)

  end

  #
  # test that an identifier search returns only the exact item
  #

  #
  # test that a date search includes an expected item
  #

  #
  # test that a date range includes an expected item
  #

end

#
# end of file
#
