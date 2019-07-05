require 'base64'
require 'digest'
require 'jwt'
require 'rest-client'
require 'logger'
require 'oj'
require 'active_model'
require 'dry-validation'

require 'genba/version'
require 'genba/reservation_request'
require 'genba/order_request'
require 'genba/action_request'
require 'genba/activation_request'
require 'genba/redemption_request'

require 'genba/util'
require 'genba/client/products'
require 'genba/client/prices'
require 'genba/client/promotions'
require 'genba/client/reservations'
require 'genba/client/orders'
require 'genba/client/direct_entitlement'
require 'genba/client/direct_entitlements/activations'
require 'genba/client/direct_entitlements/redemptions'
require 'genba/client'

# Genba API module
module Genba
  @logger = nil

  # map to the same values as the standard library's logger
  LEVEL_DEBUG = Logger::DEBUG
  LEVEL_ERROR = Logger::ERROR
  LEVEL_INFO = Logger::INFO

  def self.client(credentials = {})
    Client.new(credentials)
  end

  # When set prompts the library to log some extra information to $stdout and
  # $stderr about what it's doing. For example, it'll produce information about
  # requests, responses, and errors that are received. Valid log levels are
  # `debug` and `info`, with `debug` being a little more verbose in places.
  #
  # Use of this configuration is only useful when `.logger` is _not_ set. When
  # it is, the decision what levels to print is entirely deferred to the logger.
  def self.log_level
    @log_level
  end

  def self.log_level=(val)
    # Backwards compatibility for values that we briefly allowed
    if val == 'debug'
      val = LEVEL_DEBUG
    elsif val == 'info'
      val = LEVEL_INFO
    end

    if !val.nil? && ![LEVEL_DEBUG, LEVEL_ERROR, LEVEL_INFO].include?(val)
      raise ArgumentError, "log_level should only be set to `nil`, `debug` or `info`"
    end
    @log_level = val
  end

  # Sets a logger to which logging output will be sent. The logger should
  # support the same interface as the `Logger` class that's part of Ruby's
  # standard library (hint, anything in `Rails.logger` will likely be
  # suitable).
  #
  # If `.logger` is set, the value of `.log_level` is ignored. The decision on
  # what levels to print is entirely deferred to the logger.
  def self.logger
    @logger
  end

  def self.logger=(val)
    @logger = val
  end
end

Genba.log_level = ENV['GENBA_LOG'] unless ENV['GENBA_LOG'].nil?
