#
# Namespace for the Socializer engine
#
module Socializer
  module Activities
    class LikesController < ApplicationController
      before_action :authenticate_user

      # GET /activities/1/likes
      # Get a list of people who like the activity
      def index
        activity = Activity.find_by(id: params[:id])

        @people = activity.activity_object.liked_by

        respond_to do |format|
          format.html { render layout: false if request.xhr? }
        end
      end

      # POST /activities/1/like
      def create
        @likable  = find_likable
        @activity = find_activity(likable: @likable)
        @likable.like(current_user) unless current_user.likes?(@likable)

        respond_to do |format|
          format.js
        end
      end

      # DELETE /activities/1/unlike
      def destroy
        @likable  = find_likable
        @activity = find_activity(likable: @likable)
        @likable.unlike(current_user) if current_user.likes?(@likable)

        respond_to do |format|
          format.js
        end
      end

      private

      def find_likable
        ActivityObject.find_by(id: params[:id])
      end

      def find_activity(likable:)
        likable.activitable.decorate
      end

      # # Never trust parameters from the scary internet, only allow the white list through.
      # def like_params
      #   params.require(:like).permit(:actor_id, :activity_object_id)
      # end
    end
  end
end
