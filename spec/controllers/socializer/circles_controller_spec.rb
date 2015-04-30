require 'rails_helper'

module Socializer
  RSpec.describe CirclesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, a circle, and valid+attributes
    let(:user) { create(:socializer_person) }
    let(:circle) { create(:socializer_circle, activity_author: user.activity_object) }
    let(:valid_attributes) { { circle: { author_id: user.guid, display_name: 'Test' } } }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'GET #index' do
      before :each do
        get :index
      end

      it 'assigns @circles' do
        expect(assigns(:circles)).to match_array([circle])
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #show' do
      before :each do
        get :show, id: circle
      end

      it 'assigns the requested circle to @circle' do
        expect(assigns(:circle)).to eq circle
      end

      it 'renders the show template' do
        expect(response).to render_template :show
      end

      it 'returns http success' do
        get :show, id: circle
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #new' do
      before :each do
        get :new
      end

      it 'assigns a new Group to @circle' do
        expect(assigns(:circle)).to be_a_new(Circle)
      end

      it 'renders the :new template' do
        expect(response).to render_template :new
      end

      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new circle in the database' do
          expect { post :create, valid_attributes }.to change(Circle, :count).by(1)
        end

        it 'redirects to circles#contacts' do
          post :create, valid_attributes
          expect(response).to redirect_to contacts_circles_path
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'GET #edit' do
      before :each do
        get :edit, id: circle
      end

      it 'assigns the requested circle to @circle' do
        expect(assigns(:circle)).to eq circle
      end

      it 'renders the :edit template' do
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'redirects to the updated circle' do
          patch :update, id: circle, circle: { display_name: 'Test1' }
          expect(response).to redirect_to circle
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the circle' do
        circle
        expect { delete :destroy, id: circle }.to change(Circle, :count).by(-1)
      end

      it 'redirects to contacts#index' do
        delete :destroy, id: circle
        expect(response).to redirect_to contacts_circles_path
      end
    end
  end
end