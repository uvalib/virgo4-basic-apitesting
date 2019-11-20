#
#
#

require 'airborne'

describe 'master' do

  before do
    Airborne.configuration.base_url = 'https://search-ws-dev.internal.lib.virginia.edu'
    Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer bkb4notbo1bc80d2uucg' }
    Airborne.configuration.verify_ssl = false
  end

  it 'should return the correct structure' do
     post '/api/search', { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }

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
