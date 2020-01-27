#
#
#

require 'airborne'

describe 'master' do

  # define the endpoints
  version_endpoint = '/version'
  search_endpoint = '/api/search'
  pools_endpoint = '/api/pools'

  before do
    Airborne.configuration.base_url = 'https://search-ws-dev.internal.lib.virginia.edu'
    Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer bkb4notbo1bc80d2uucg' }
    Airborne.configuration.verify_ssl = false
  end

  #
  # tests that the pools endpoint returns json that includes some pools
  #
  it 'pools should return json containing pools' do
    get pools_endpoint
    expect_status( 200 )
    expect(headers[:content_type]).to eq('application/json; charset=utf-8')
    expect_json_types(:array)
    expect json_body.count == 8
    expect_json_types('*', id: :string, url: :string, name: :string, description: :string)
    
  end

  it 'should return the correct search response structure' do
     post search_endpoint, { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
     expect_status( 200 )

     expect_json_types( request: :object)
     expect_json_types( pools: :array_of_objects)
     expect_json_types( pool_results: :array_of_objects)
     expect_json_types( warnings: :array)
     expect_json_types( total_time_ms: :int)
     expect_json_types( total_hits: :int)
     #puts json_body
     #puts body
     #puts headers
  end

end

#
# end of file
#
