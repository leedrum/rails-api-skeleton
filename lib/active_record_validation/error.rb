# frozen_string_literal: true

module ActiveRecordValidation
  class Error
    attr_reader :record

    def initialize record
      @record = record
    end

    def serialize full_message: true
      return unless record

      full_messages = record.errors.to_hash full_message
      record.errors.details.map do |field, details|
        detail = details.first
        message = full_messages[field].first
        convert_to_serializer field, detail, message
      end.flatten
    end

    def convert_to_serializer field, detail, message
      ValidationErrorSerializer.new(record, field, detail, message).serialize
    end

    def to_hash
      {
        success: false,
        errors: serialize
      }
    end
  end
end
