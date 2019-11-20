#
#
#

require 'airborne'

describe 'pool' do

  before do
    Airborne.configuration.base_url = 'https://pool-solr-ws-catalog-dev.internal.lib.virginia.edu'
    Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer bkb4notbo1bc80d2uucg' }
    Airborne.configuration.verify_ssl = false
  end

  it 'should return the correct structure' do
     post '/api/search', { :query => "author:{jefferson}", :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }

     expect_json_types( identity: :object)
     expect_json_types( pagination: :object)
     expect_json_types( group_list: :array_of_objects)
     expect_json_types( confidence: :string)
     expect_json_types( elapsed_ms: :int)
     #puts json_body
     #puts body
     #puts headers
  end

end

#
# end of file
#
