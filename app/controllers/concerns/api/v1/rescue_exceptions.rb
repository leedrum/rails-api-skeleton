# frozen_string_literal: true

module Api
  module V1
    module RescueExceptions
      extend ActiveSupport::Concern

      included do # rubocop:disable Metrics/BlockLength
        rescue_from ActionController::ParameterMissing, JSON::ParserError, ArgumentError do |_error|
          render_invalid_params_response
        end
        rescue_from(
          ActiveRecord::RecordInvalid,
          ActiveRecord::RecordNotDestroyed,
          with: :render_unprocessable_entity_response
        )
        rescue_from ActiveRecord::RecordNotUnique, with: :render_existing_resource_response
        rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found_response
        rescue_from(
          Api::Error::ServiceExecuteFailed,
          Api::Error::FormExecuteFailed,
          Api::Error::ControllerRuntimeError,
          with: :render_execute_failed_response
        )
        rescue_from ActionController::RoutingError, with: :render_routing_error_response
        rescue_from Api::Error::ActionNotAllowed, with: :render_action_not_allowed_response
        rescue_from Api::Error::UnauthorizedRequest, with: :render_unauthorized_reponse
        rescue_from Api::Error::InvalidRecaptcha, with: :render_invalid_recaptcha_reponse
        rescue_from(
          Pagy::OverflowError,
          Aws::S3::Errors,
          ActiveRecord::ValueTooLong,
          with: :render_service_unavailable_error_response
        )
        rescue_from JWT::DecodeError, with: :render_jwt_decode_error_response
        rescue_from JWT::ExpiredSignature, with: :render_expired_signature_error_response

        protected
        def render_invalid_params_response status: :bad_request
          error = Api::BaseError.new I18n.t("errors.params.invalid")
          render json: error.to_hash, status: status
        end

        def render_unprocessable_entity_response exception, status: :bad_request
          render json: ActiveRecordValidation::Error.new(exception.record).to_hash, status: status
        end

        def render_existing_resource_response _exception, status: :bad_request
          error = Api::BaseError.new I18n.t("errors.active_record.not_unique")
          render json: error.to_hash, status: status
        end

        def render_execute_failed_response exception, status: :bad_request
          render json: exception.to_hash, status: status
        end

        def render_resource_not_found_response exception, status: :not_found
          render json: Api::Error::RecordNotFound.new(exception).to_hash, status: status
        end

        def render_routing_error_response _exception, status: :not_found
          error = Api::BaseError.new I18n.t("errors.route.not_found")
          render json: error.to_hash, status: status
        end

        def render_action_not_allowed_response exception, status: :forbidden
          render json: Api::Error::ActionNotAllowed.new(exception).to_hash, status: status
        end

        def render_unauthorized_reponse exception, status: :unauthorized
          render json: exception.to_hash, status: status
        end

        def render_invalid_recaptcha_reponse exception, status: :bad_request
          render json: exception.to_hash, status: status
        end

        def render_service_unavailable_error_response _exception, status: :service_unavailable
          error = Api::BaseError.new I18n.t("errors.params.service_unavailable")
          render json: error.to_hash, status: status
        end

        def render_jwt_decode_error_response _exception, status: :unauthorized
          error = Api::BaseError.new I18n.t("errors.action.unauthorized")
          render json: error.to_hash, status: status
        end

        def render_expired_signature_error_response _exception, status: :unauthorized
          error = Api::BaseError.new I18n.t("unauthorized.errors.expired_signature")
          render json: error.to_hash, status: status
        end
      end
    end
  end
end
