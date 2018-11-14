# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Restrictions do
  it '#get_restrictions' do
    stub_request(:get, 'https://api.genbagames.com/api/restrictions')
      .to_return(body: ApiStubHelpers.restrictions)
    restrictions = @client.restrictions.get_restrictions
    expect(restrictions.length).to be > 0
    restriction = restrictions.first
    expect(restriction.key?('productName')).to be_truthy
    expect(restriction.key?('productSKU')).to be_truthy
    expect(restriction.key?('productSKUId')).to be_truthy
    expect(restriction.key?('blacklistedCountries')).to be_truthy
    expect(restriction.key?('blacklistedCountriesISO')).to be_truthy
    expect(restriction.key?('whitelistCountries')).to be_truthy
    expect(restriction.key?('whitelistCountriesISO')).to be_truthy
  end
end
