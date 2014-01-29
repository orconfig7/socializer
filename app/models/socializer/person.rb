require 'digest/md5'

module Socializer
  class Person < ActiveRecord::Base
    # extend Enumerize
    include Socializer::ObjectTypeBase

    # enumerize :avatar_provider, in: { twitter: 1, facebook: 2, linkedin: 3, gravatar: 4 }, default: :gravatar, predicates: true, scope: true

    attr_accessible :display_name, :email, :language, :avatar_provider

    has_many :authentications
    has_many :notifications

    validates :avatar_provider, inclusion: %w( TWITTER FACEBOOK LINKEDIN GRAVATAR )

    def services
      @services ||= authentications.where { provider.not_eq('Identity') }
    end

    def circles
      @circles ||= activity_object.circles
    end

    def comments
      @comments ||= activity_object.comments
    end

    def notes
      @notes ||= activity_object.notes
    end

    def groups
      @groups ||= activity_object.groups
    end

    def memberships
      @memberships ||= activity_object.memberships
    end

    def received_notifications
      fail 'Method not implemented yet.'
    end

    def contacts
      @contacts ||= circles.map { |c| c.contacts }.flatten.uniq
    end

    def contact_of
      @contact_of ||= Circle.joins { ties }.where { ties.contact_id.eq my { guid } }.map { |circle| circle.author }.uniq
    end

    # FIXME: If you like, unlike, and then like again the activity doesn't show up
    #        This was true before the refactoring
    def likes
      activity_obj_id = activity_object.id
      query  = Activity.joins { verb }.where { actor_id.eq(activity_obj_id) & target_id.eq(nil) }
      unlike = query.where { verb.name.eq('unlike') }.select { activity_object_id }

      @likes ||= query.where { verb.name.eq('like') }.where { activity_object_id.not_in(unlike) }
    end

    # REFACTOR: It may make more sense to retreive the activity object where the verb is like or unlike order by updated_at desc limit 1
    def likes?(object)
      activity_obj_id = activity_object.id

      query   = Activity.joins { verb }.where { activity_object_id.eq(object.id) & actor_id.eq(activity_obj_id) }
      likes   = query.where { verb.name.eq('like') }
      unlikes = query.where { verb.name.eq('unlike') }

      # Can replace the 3 return statements, but always runs 2 queries
      # !(likes.present? && unlikes.present?)

      return false if likes.count == 0
      return false if likes.count == unlikes.count
      true
    end

    def pending_memberships_invites
      privacy_private = Group.privacy_level.find_value(:private).value
      @pending_memberships_invites ||= Membership.joins { group }.where { member_id.eq(my { guid }) & active.eq(false) & group.privacy_level.eq(privacy_private) }
    end

    # TODO: avatar_url - clean this up
    def avatar_url
      avatar_provider_array = %w( FACEBOOK LINKEDIN TWITTER )

      if avatar_provider_array.include?(avatar_provider)
        provider = avatar_provider.downcase
        authentications.where(provider: provider).first.try(:image_url)
      else
        return if email.blank?
        "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
      end

      # if avatar_provider == 'FACEBOOK'
      #   authentications.where(provider: 'facebook')[0].image_url if authentications.where(provider: 'facebook')[0].present?
      # elsif avatar_provider == 'TWITTER'
      #   authentications.where(provider: 'twitter')[0].image_url if authentications.where(provider: 'twitter')[0].present?
      # elsif avatar_provider == 'LINKEDIN'
      #   authentications.where(provider: 'linkedin')[0].image_url if authentications.where(provider: 'linkedin')[0].present?
      # else
      #   "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}" if email.present?
      # end
    end

    def self.create_with_omniauth(auth)
      create! do |user|

        user.display_name = auth.info.name
        user.email = auth.info.email
        image_url = auth.info.image

        if image_url.nil?
          image_url = ''
          user.avatar_provider = 'GRAVATAR'
        else
          user.avatar_provider = auth.provider.upcase
        end

        user.authentications.build(provider: auth.provider, uid: auth.uid, image_url: image_url)

      end
    end
  end
end
