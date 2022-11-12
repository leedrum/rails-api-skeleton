# frozen_string_literal: true

module Api
  class BaseError < StandardError
    attr_reader :code, :message

    def initialize code: nil, message: nil
      super
      @code = code
      @message = message
    end

    def serialize
      [{code: @code, message: @message}]
    end

    def to_hash
      {
        success: false,
        errors: serialize
      }
    end
  end

  class ExecuteFailed < BaseError
    attr_reader :type, :file_path, :i18n_scope

    def initialize type, error_detail
      super
      @type = type
      @file_path = caller(0, 3).last.match(file_path_regex)[0]
      @i18n_scope = file_path.split(%r{/})[3..].map {|e| e.gsub file_suffix, ""}
      error = I18n.t error_detail, scope: i18n_scope
      @code = error[:code]
      @message = error[:message]
    end

    private

    def file_path_regex
      case type
      when :controller
        %r{/app/(controllers)/.*.rb}
      when :service
        %r{/app/(services)/.*.rb}
      when :form
        %r{/app/(forms)/.*.rb}
      end
    end

    def file_suffix
      case type
      when :controller
        /_controller.rb/
      when :service
        /_service.rb/
      when :form
        /_form.rb/
      end
    end
  end

  module Error
    # TODO: define custom error class (extends the BaseError) here.
    class ServiceExecuteFailed < ExecuteFailed
      def initialize error_detail
        super
        super :service, error_detail
      end
    end

    class FormExecuteFailed < ExecuteFailed
      def initialize error_detail
        super
        super :form, error_detail
      end
    end

    class ControllerRuntimeError < ExecuteFailed
      def initialize error_detail
        super
        super :controller, error_detail
      end
    end

    class RecordNotFound < BaseError
      attr_reader :error

      def initialize error
        super
        @error = error
      end

      def to_hash
        RecordNotFoundSerializer.new(error).serialize
      end
    end

    class ActionNotAllowed < BaseError
      attr_reader :error

      def initialize error
        super
        @error = error
      end

      def to_hash
        ActionNotAllowedSerializer.new(error).serialize
      end
    end

    class UnauthorizedRequest < BaseError
      attr_reader :error

      def initialize error = nil
        super
        @error = error
      end

      def to_hash
        UnauthorizedRequestSerializer.new(error).serialize
      end
    end

    class InvalidRecaptcha < BaseError
      attr_reader :error

      def initialize error = nil
        super
        error = I18n.t error
        @code = error[:code]
        @message = error[:message]
      end

      def to_hash
        InvalidRecaptchaSerializer.new(code, message).serialize
      end
    end
  end
end
