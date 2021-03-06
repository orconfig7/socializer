# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Groups::PublicController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/groups/public")
          .to route_to("socializer/groups/public#index")
      end

      it "does not route to #new" do
        expect(get: "/groups/public/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/groups/public/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/groups/public/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/groups/public").not_to be_routable
      end

      context "does not route to #update" do
        it { expect(patch: "/groups/public/1").not_to be_routable }
        it { expect(put: "/groups/public/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/groups/public/1").not_to be_routable
      end
    end
  end
end
