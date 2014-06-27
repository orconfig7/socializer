#
# Namespace for the Socializer engine
#
module Socializer
  class GroupsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group, only: [:edit, :update, :destroy]

    # GET /groups
    def index
    end

    # GET /groups/1
    def show
      @group = Group.find_by(id: params[:id])
      @membership = Membership.find_by(group_id: @group.id)
    end

    # GET /groups/new
    def new
      @group = Group.new
    end

    # GET /groups/1/edit
    def edit
    end

    # POST /groups
    def create
      @group = current_user.groups.build(params[:group])

      if @group.save
        redirect_to @group
      else
        render :new
      end
    end

    # PATCH/PUT /groups/1
    def update
      @group.update!(params[:group])
      redirect_to @group
    end

    # DELETE /groups/1
    def destroy
      @group.destroy
      redirect_to groups_path
    end

    def public
      @groups = Group.public
    end

    def restricted
      @groups = Group.restricted
    end

    def joinable
      @groups = Group.joinable
    end

    def memberships
      @memberships = current_user.memberships
    end

    def ownerships
      @ownerships = current_user.groups
    end

    def pending_invites
      @pending_invites = current_user.pending_memberships_invites
    end

    private

    def set_group
      @group = current_user.groups.find_by(id: params[:id])
    end
  end
end
