# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::DirectEntitlement::Redemptions do
  let(:sku_id) { '98b9d3d8-dac2-4454-96cd-0011607500f0' }

  it '#perform' do
    stub_request(:post, /api\/v3-0\/directentitlement\/redemptions/)
      .to_return(body: '{}')

    payload = {
      ClientTransactionID: 'ClientTransactionID',
      ActivationID: 'ActivationID',
      Redemption: {
        EndUserID: 'EndUserID',
        EndUserTicket: 'EndUserTicket'
      }
    }

    key_res = @client.direct_entitlement.redemptions.perform(payload)
  end

  it '#get' do
    stub_request(:get, /api\/v3-0\/directentitlement\/redemptions\/.+/)
      .to_return(body: '{}')

    key_res = @client.direct_entitlement.redemptions.get('redemption_id')
  end

  it '#perform_action' do
    payload = {
      Action: 'Action',
      Reason: 'Reason'
    }

    stub_request(:post, /api\/v3-0\/directentitlement\/redemptions\/.+/)
      .to_return(body: '{}')

    key_res = @client.direct_entitlement.redemptions.perform_action('redemption_id', payload)
  end

  it '#get_by_ctid' do
    stub_request(:get, /api\/v3-0\/directentitlement\/redemptions\/ctid\/.+/)
      .to_return(body: '{}')

    key_res = @client.direct_entitlement.redemptions.get_by_ctid('ctid')
  end
end
