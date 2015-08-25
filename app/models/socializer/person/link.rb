#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Link model
    #
    # URLs that are interesting to the {Socializer::Person person}
    #
    class Link < ActiveRecord::Base
      attr_accessible :display_name, :url

      # Relationships
      belongs_to :person

      # Validations
      validates :display_name, presence: true
      validates :person, presence: true
      validates :url, presence: true
    end
  end
end