# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do
    let(:params) do
      {
        email:,
        password:,
        password_confirmation: password
      }
    end
    let(:email) {Faker::Internet.email}
    let(:password) {"Aa@123456"}
    let(:body) {JSON.parse response.body}

    before do
      post api_v1_user_registration_url, params:
    end

    context "normal case" do
      it "should create user successfully" do
        expect(response.code).to eq "200"
      end

      it "should create only 1 user" do
        expect(User.count).to eq 1
      end

      it "should create with correct params" do
        expect(User.first.email).to eq email
      end
    end

    context "email is empty" do
      let(:email) {""}

      it "should response failure" do
        expect(response.code).to eq "422"
        expect(body["status"]).to eq "error"
        expect(body["errors"]["email"].count).to eq 1
        expect(body["errors"]["email"].first).to eq "can't be blank"
      end
    end

    context "email is invalid" do
      let(:email) {"invalid email"}

      it "should response failure" do
        expect(response.code).to eq "422"
        expect(body["status"]).to eq "error"
        expect(body["errors"]["email"].count).to eq 1
        expect(body["errors"]["email"].first).to eq "is not an email"
      end
    end

    context "password is invalid" do
      let(:password) {"123"}

      it "should response failure" do
        expect(response.code).to eq "422"
        expect(body["status"]).to eq "error"
      end
    end
  end
end
