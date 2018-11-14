# frozen_string_literal: true

# keyBlackListRequest
class KeyBlackListRequest
  include ActiveModel::Validations
  attr_accessor :key_id, :reason_text

  validates :key_id, presence: true, allow_blank: false
  validates :reason_text, presence: true, allow_blank: false

  def initialize(key_id, reason_text)
    @key_id = key_id
    @reason_text = reason_text
  end

  def to_genba_json_payload
    {
      keyId: @key_id,
      reasonText: @reason_text
    }.select { |_, v| !v.nil? }
  end
end
