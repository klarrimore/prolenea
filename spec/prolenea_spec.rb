require 'spec_helper'

RSpec.describe Prolenea do

  before :each do
    stub_request(:get, 'http://test.example.com/?dial=12125551000').to_return(:status => 200, :body => "bad body", :headers => {})
    stub_request(:get, 'http://test.example.com/?dial=12125551001').to_return(:status => 404, :body => "", :headers => {})
    stub_request(:get, 'http://test.example.com/?dial=12125551002').to_return(:status => 200, :body => "2125551002\r\n-\r\n-\r\n-\r\n-\r\n-\r\nMULT\r\nMULTIPLE OCN LISTING\r\n99999\r\nCUSTOMER DIRECTORY ASSISTANCE\r\nNY", :headers => {})

    options = {:uri => 'http://test.example.com'}

    Prolenea.connect options
  end

  it 'has a version number' do
    expect(Prolenea::VERSION).not_to be nil
  end

  it 'throws a ProleneaLookupError if the body is malformed' do
    expect { Prolenea.lookup_number('12125551000') }.to raise_error(ProleneaLookupError)
  end

  it 'throws a ProleneaLookupError if HTTP response code is not 200' do
    expect { Prolenea.lookup_number('12125551001') }.to raise_error(ProleneaLookupError)
  end

  it 'returns JSON if there is a 200 HTTP response code and valid body' do
    expect(Prolenea.lookup_number('12125551002')).to be_a_kind_of(Hash)
  end
end
