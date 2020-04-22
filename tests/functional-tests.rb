require 'airborne'
require './tests/helpers'

describe 'functions' do
  # define the endpoints
  search_endpoint = '/api/search'

  #get authentication token
  authtoken = RestClient.post ENV['AUTH_URL'], ""
  
  # test one item is included
  def test_include(all,one)
    return expect(all).to include(one)
  end

  url = ENV['URL']

  before do
    Airborne.configuration.base_url = url
    Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer '+ authtoken }
    Airborne.configuration.verify_ssl = false
  end

  #
  # Test for title/subtitle search
  #
  it "#{url} should return exact title/subtitle match" do
    search_title = "The card catalog: books, cards, and literary treasures"

    post search_endpoint, { :query => "keyword:{\"#{search_title}\"}", :pagination => { :start => 0, :rows => 1 }}
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0

    first_titles = Helpers.pool_results_first_title( json_body )
    first_subtitle = Helpers.pool_results_first_subtitle( json_body )
    search_result = first_titles + ": "+ first_subtitle

    expect(search_result).to include(search_title)

  end


end
