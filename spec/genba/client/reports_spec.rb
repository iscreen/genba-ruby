# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Reports do
  it '#publisher_raw_data' do
    stub_request(:get, /api.genbagames.com\/api\/report\/publisher\/rawdata\?Year=/)
      .to_return(body: '')

    reports = @client.reports.publisher_raw_data
  end
end
