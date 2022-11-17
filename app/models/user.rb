# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :trackable, :validatable, :registerable
  #  :omniauthable

  include DeviseTokenAuth::Concerns::User

  before_validation :set_provider

  private

  def set_provider
    self[:provider] = "email" if self[:provider].blank?
  end
end
