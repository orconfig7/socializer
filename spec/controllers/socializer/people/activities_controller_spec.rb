require 'rails_helper'

module Socializer
  RSpec.describe People::ActivitiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and activities
    let(:user) { create(:socializer_person) }
    let(:activities) { Activity.person_stream(actor_uid: user.id, viewer_id: user.id).decorate }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    it { should use_before_action(:authenticate_user) }

    describe 'GET #index' do
      before :each do
        get :index, person_id: user
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns @person' do
        expect(assigns(:person)).to match(user)
      end

      it 'assigns @title' do
        expect(assigns(:title)).to match(user.display_name)
      end

      it 'assigns @current_id' do
        expect(assigns(:current_id)).to eq(user.guid)
      end

      it 'assigns @activities' do
        expect(assigns(:activities)).to match_array(activities)
      end
    end
  end
end