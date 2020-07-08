require 'airborne'
require './tests/helpers'

describe 'functions' do
  # define the endpoints
  search_endpoint = '/api/search'
  pools_endpoint = 'https://search-ws.internal.lib.virginia.edu/api/pools'

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
  # Test for title/subtitle search
  #
  it "#{url} should return exact title/subtitle match" do
    search_title = "The Card Catalog: Books, Cards, and Literary Treasures"

    post search_endpoint, { :query => "keyword:{\"#{search_title}\"}", :pagination => { :start => 0, :rows => 1 }}
    expect_status( 200 )

    expect( json_body[:group_list].count ).to be > 0

    first_titles = Helpers.pool_results_first_title( json_body )
    #first_subtitle = Helpers.pool_results_first_subtitle( json_body )
    #search_result = first_titles + ": "+ first_subtitle
    #expect(search_result).to include(search_title)
    expect(first_titles).to include(search_title)

  end

  it "#{url} should return at least one result for a * search" do
    post search_endpoint, { :query => "keyword:{*}", :pagination => { :start => 0, :rows => 1 }}
    expect_status( 200 )
    expect( json_body[:group_list].count ).to be > 0
    expect(Helpers.pool_results_first_title( json_body )).not_to be nil?

  end

  it "#{url} should return response for all the pools" do
    articles_url = "https://pool-eds-ws.internal.lib.virginia.edu"
    books_url = "https://pool-solr-ws-catalog.internal.lib.virginia.edu"
    images_url = "https://pool-solr-ws-images.internal.lib.virginia.edu"
    journals_url = "https://pool-solr-ws-serials.internal.lib.virginia.edu"
    manuscript_archives_url = "https://pool-solr-ws-archival.internal.lib.virginia.edu"
    maps_url = "https://pool-solr-ws-maps.internal.lib.virginia.edu"
    music_recordings_url = "https://pool-solr-ws-music-recordings.internal.lib.virginia.edu"
    musical_scores_url = "https://pool-solr-ws-musical-scores.internal.lib.virginia.edu"
    sound_recordings_url = "https://pool-solr-ws-sound-recordings.internal.lib.virginia.edu"
    theses_url = "https://pool-solr-ws-thesis.internal.lib.virginia.edu"
    videos_url = "https://pool-solr-ws-video.internal.lib.virginia.edu"
    get pools_endpoint
    expect_status( 200 )
    urls=[]
    json_body.each do | entry|
      urls << entry[:url]
    end
    expect(urls).to include(articles_url)
    expect(urls).to include(books_url)
    expect(urls).to include(images_url)
    expect(urls).to include(journals_url)
    expect(urls).to include(manuscript_archives_url)
    expect(urls).to include(maps_url)
    expect(urls).to include(music_recordings_url)
    expect(urls).to include(musical_scores_url)
    expect(urls).to include(sound_recordings_url)
    expect(urls).to include(theses_url)
    expect(urls).to include(videos_url)
  end


end
