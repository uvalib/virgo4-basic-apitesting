#
# basic set of pool tests per: https://confluence.lib.virginia.edu/pages/viewpage.action?spaceKey=VIRGO4&title=Automated+Tests
#

require 'airborne'
require './tests/helpers'

describe 'pool' do
  # define the endpoints
  search_endpoint = '/api/search'
  facet_endpoint = '/api/search/facets'
  identify_endpoint = '/identify'

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
    #Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer bkb4notbo1bc80d2uucg' }
    Airborne.configuration.headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => 'Bearer '+ authtoken }
    Airborne.configuration.verify_ssl = false
  end
  #
  # tests that the search call returns reported JSON
  #
  it "#{url} search should return json" do
    post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect(headers[:content_type]).to eq('application/json; charset=utf-8')

  end

  #
  # tests that the facet call returns reported JSON
  #
  it "#{url} search should return json" do
    post facet_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect(headers[:content_type]).to eq('application/json; charset=utf-8')
  end

  #
  # tests that we have a reasonable structure in response to a search request
  #
  it "#{url} should return the correct search response structure" do
    post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
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
  it "#{url} should return the correct facet response structure" do
    post facet_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
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
  it "#{url} should return one or more items" do
    post search_endpoint, { :query => "author:{*}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
  end

  #
  # test that a facet search returns at least 1 facet
  #
  it "#{url} should return one or more facets" do
    post facet_endpoint, { :query => "author:{*}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:facet_list].count ).to be > 0
  end

  #
  # test that a multi-word known title search returns an item with that known title first
  #
  it "#{url} should return exact title match" do
    post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
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

    test_include(all_titles,first_title)
  end

  #
  # test that a subject search returns items with the identical subject
  #
  it "#{url} should return exact subject match" do
    post search_endpoint, { :query => "subject:{*}", :pagination => { :start => 0, :rows => 1 }}
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0

    # extract the first subject from the results
    first_subject = Helpers.pool_results_first_subject( json_body )

    # search for all items with this subject
    post search_endpoint, { :query => "subject:{\"#{first_subject}\"}", :pagination => { :start => 0, :rows => 25 }, :filters => nil, :preferences => { :target_pool => "", :exclude_pool => nil } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
    all_subjects = Helpers.pool_results_all_subjects( json_body )

    test_include(all_subjects,first_subject)
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
  it "#{url} support searching by date range" do
    post search_endpoint,   { :query => all_items_query, :pagination => { :start => 0, :rows => 1 }}
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0

    # extract the first publication date from the results
    first_pub_date = Helpers.pool_results_first_pub_date( json_body )

    # extract the first title from the results
    first_id = Helpers.pool_results_first_identifier( json_body )

    # search for one item within this date range
    # puts "date:{#{first_pub_date.to_i - 1} TO #{first_pub_date.to_i + 1}} AND author:{jefferson}"
    post search_endpoint, { :query => "date:{#{first_pub_date.to_i - 1} TO #{first_pub_date.to_i + 1}} AND author:{jefferson}", :pagination => { :start => 0, :rows => 1 } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
    all_ids = Helpers.pool_results_all_identifiers( json_body )

    test_include(all_ids, first_id)

    # no items should return out of the date range
    post search_endpoint, { :query => "date:{BEFORE #{first_pub_date.to_i - 1}} AND author:{jefferson}", :pagination => { :start => 0, :rows => 1 } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
    all_ids = Helpers.pool_results_all_identifiers( json_body )

    expect(all_ids).not_to include(first_id)

    post search_endpoint, { :query => "date:{AFTER #{first_pub_date.to_i + 1}} AND author:{jefferson}", :pagination => { :start => 0, :rows => 1 } }
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
    all_ids = Helpers.pool_results_all_identifiers( json_body )

    expect(all_ids).not_to include(first_id)
  end

  #
  # test an identifier search
  #

  it "#{url} should return exact identifier match" do
    post search_endpoint, { :query => "keyword:{}", :pagination => { :start => 0, :rows => 1 }}
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0

    # extract the first identifier from the results
    first_identifier = Helpers.pool_results_first_identifier( json_body )

    # search for one item with this identifier
    post search_endpoint, { :query => "identifier:{#{first_identifier}}", :pagination => { :start => 0, :rows => 1 }}
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0
    all_identifiers = Helpers.pool_results_first_identifier( json_body )

    test_include(all_identifiers, first_identifier)
  end

  it "#{url} should return sort order availability" do
    get identify_endpoint
    expect_status( 200 )

    sorting_status = Helpers.get_sorting_status(json_body)
    if sorting_status == false
      puts "This pool doesn't support sorting"
    else
      if json_body[:name] == ("Books" || "Images")
        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortDatePublished", :order => "asc"}}
        expect(json_body[:sort][:sort_id]).to eq("SortDatePublished")
        expect(json_body[:sort][:order]).to eq("asc")

        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortDatePublished", :order => "desc"}}
        expect(json_body[:sort][:sort_id]).to eq("SortDatePublished")
        expect(json_body[:sort][:order]).to eq("desc")

        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortRelevance", :order => "desc"}}
        expect(json_body[:sort][:sort_id]).to eq("SortRelevance")
        expect(json_body[:sort][:order]).to eq("desc")

        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortCallNumber", :order => "asc"}}
        expect(json_body[:sort][:sort_id]).to eq("SortCallNumber")
        expect(json_body[:sort][:order]).to eq("asc")

        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortCallNumber", :order => "desc"}}
        expect(json_body[:sort][:sort_id]).to eq("SortCallNumber")
        expect(json_body[:sort][:order]).to eq("desc")

        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortAuthor", :order => "asc"}}
        expect_status(400)
      end
      if json_body[:name] == "Articles"
        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortRelevance", :order => "desc"}}
        expect(json_body[:sort][:sort_id]).to eq("SortRelevance")
        expect(json_body[:sort][:order]).to eq("desc")

        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortDate", :order => "asc"}}
        expect(json_body[:sort][:sort_id]).to eq("SortDate")
        expect(json_body[:sort][:order]).to eq("asc")

        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortDate", :order => "desc"}}
        expect(json_body[:sort][:sort_id]).to eq("SortDate")
        expect(json_body[:sort][:order]).to eq("desc")

        post search_endpoint, { :query => all_items_query, :pagination => { :start => 0, :rows => 1 },:sort => { :sort_id => "SortAuthor", :order => "asc"}}
        expect_status(200)
      end
    end

  end

end

#
# end of file
#
