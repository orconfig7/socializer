require 'spec_helper'

module Socializer
  describe Activity do
    pending "add additional examples to #{__FILE__}"

    # Define a person for common testd instead of build one for each
    let(:activity) { FactoryGirl.build(:socializer_activity) }

    it 'has a valid factory' do
      expect(activity).to be_valid
    end

    it '#respond to notifications' do
      expect(activity).to respond_to(:notifications)
    end

  end
end
