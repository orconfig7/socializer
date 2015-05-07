require 'rails_helper'

module Socializer
  RSpec.describe Activities::SharesController, type: :routing do
    routes { Socializer::Engine.routes }

    describe 'routing' do
      it 'does not route to #index' do
        expect(get: '/activities/1/shares').to_not be_routable
      end

      it 'routes to #new' do
        expect(get: '/activities/1/share').to route_to('socializer/activities/shares#new', id: '1')
      end

      it 'does not route to #show' do
        expect(get: '/activities/1/shares/show/1').to_not be_routable
      end

      it 'does not route to #edit' do
        expect(get: '/activities/1/shares/1/edit').to_not be_routable
      end

      it 'routes to #create' do
        expect(post: '/activities/1/share').to route_to('socializer/activities/shares#create', id: '1')
      end

      it 'does not route to #update' do
        expect(patch: '/activities/1/shares/1').to_not be_routable
        expect(put: '/activities/1/shares/1').to_not be_routable
      end

      it 'does not route to #destroy' do
        expect(delete: '/activities/1/shares/1').to_not be_routable
      end
    end
  end
end