#
# basic set of pool tests per: https://confluence.lib.virginia.edu/pages/viewpage.action?spaceKey=VIRGO4&title=Automated+Tests
#

require 'airborne'
require './tests/helpers'

describe 'virgo-client' do

  # define the endpoints
  version_endpoint = '/version'
  
  before do
    Airborne.configuration.base_url = 'https://v4.lib.virginia.edu'
    Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer bkb4notbo1bc80d2uucg' }
    Airborne.configuration.verify_ssl = false
  end

  #
  # tests that the version endpoint returns json that includes a build and version
  #
  it 'version should return json' do
    get version_endpoint
    expect_status( 200 )
    expect(headers[:content_type]).to eq('application/json; charset=utf-8')
    expect_json_types( build: :string)
    expect_json_types( version: :string)
  end


end

#
# end of file
#
