#
# basic set of pool tests per: https://confluence.lib.virginia.edu/pages/viewpage.action?spaceKey=VIRGO4&title=Automated+Tests
#

require 'airborne'
require './tests/helpers'

describe 'JMRL pool' do

  # define the endpoints
  search_endpoint = '/api/search'
  identify_endpoint = '/api/identify'

  #get authentication token
  autotoken = `curl -X POST https://v4.lib.virginia.edu/authorize`

  # define all items query
  all_items_query = "author:{jefferson}"

  # test one item is included
  def test_include(all,one)
    return expect(all).to include(one)
  end

  url = ENV['URL']

  before do
    Airborne.configuration.base_url = url
    Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer '+ autotoken }
    Airborne.configuration.verify_ssl = false
  end


end
#
# end of file
#
