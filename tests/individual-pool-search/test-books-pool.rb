#
# basic set of pool tests per: https://confluence.lib.virginia.edu/pages/viewpage.action?spaceKey=VIRGO4&title=Automated+Tests
#

require 'airborne'
require './tests/helpers'

describe 'books pool' do

  # define the endpoints
  search_endpoint = '/api/search'
  facet_endpoint = '/api/search/facets'
  #identify_endpoint = '/api/identify'

  #get authentication token
  authtoken = RestClient.post ENV['AUTH_URL'], ""

  # define all items query
  all_items_query = "author:{jefferson}"

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
  #  Test a facet: select Alderman Library
  #

  it "#{url} should return exact number match" do
    post facet_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 }}
    expect_status( 200 )

    # json_body[:facet_list][3][:buckets][0] returns FacetLibrary against book pool
    numb_facetlibrary = json_body[:facet_list][3][:buckets][0][:count]

    # search for facet Library
    post search_endpoint, {:query => all_items_query ,:pagination => { :start => 0, :rows => 1 },:filters => [{:pool_id => "books",:facets => [{:facet_id => "FacetLibrary", :facet_name => "Library",:value => "Alderman"}]}]}
    expect_status( 200 )
    expect( json_body[:group_list].count ).to be > 0
    expect(json_body[:pagination][:total]).to eq(numb_facetlibrary)

  end

  #
  # Test sort order
  #

  it "#{url} should return sort order match" do
    post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortDatePublished", :order => "asc"}}
    expect(json_body[:sort][:sort_id]).to eq("SortDatePublished")
    expect(json_body[:sort][:order]).to eq("asc")

    post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortDatePublished", :order => "desc"}}
    expect(json_body[:sort][:sort_id]).to eq("SortDatePublished")
    expect(json_body[:sort][:order]).to eq("desc")

    post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortRelevance", :order => "desc"}}
    expect(json_body[:sort][:sort_id]).to eq("SortRelevance")
    expect(json_body[:sort][:order]).to eq("desc")
  end


end

#
# end of file
#
