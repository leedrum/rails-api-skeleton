# frozen_string_literal: true

module Api
  module V1
    module BaseConcern
      extend ActiveSupport::Concern

      include Api::V1::RescueExceptions
    end
  end
end
