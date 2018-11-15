require 'base64'
require 'digest'
require 'mcrypt'
require 'rest-client'
require 'oj'
require 'active_model'

require 'genba/version'
require 'genba/key_black_list_request'
require 'genba/key_report_request'
require 'genba/client/direct_entitlements'
require 'genba/client/keys'
require 'genba/client/prices'
require 'genba/client/products'
require 'genba/client/reports'
require 'genba/client/restrictions'
require 'genba/client'

# Genba API module
module Genba
  def self.client(credentials = {})
    Client.new(credentials)
  end
end
