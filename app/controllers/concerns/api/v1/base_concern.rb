# frozen_string_literal: true

module Api::V1::BaseConcern
  extend ActiveSupport::Concern

  include Api::V1::RescueExceptions
end
