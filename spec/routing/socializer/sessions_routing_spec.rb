require "rails_helper"

module Socializer
  RSpec.describe MembershipsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/sessions").to_not be_routable
      end

      it "routes to #new" do
        expect(get: "/signin").to route_to("socializer/sessions#new")
      end

      it "does not route to #show" do
        expect(get: "/sessions/1").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/sessions/1/edit").to_not be_routable
      end

      it "routes to #create" do
        expect(post: "/auth/identity/callback")
          .to route_to("socializer/sessions#create", provider: "identity")
      end

      it "does not route to #update" do
        expect(patch: "/sessions/1").to_not be_routable
      end

      it "routes to #destroy" do
        expect(delete: "/signout")
          .to route_to("socializer/sessions#destroy")
      end

      it "routes to #failure" do
        expect(post: "/auth/failure")
          .to route_to("socializer/sessions#failure")
      end
    end
  end
end