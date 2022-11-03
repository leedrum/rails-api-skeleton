# frozen_string_literal: true

require "rails_helper"

RSpec.describe HealthcheckController, type: :controller do
  describe "GET #index" do
    let(:body_response) {JSON.parse response.body, symbolize_names: true}

    describe "Success" do
      before {get :index}

      it {expect(body_response[:success]).to eq true}
    end
  end
end
