require 'test_helper'

class FermetureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

 test "should not save this without date" do
  	fermeture = Fermeture.new
  	assert fermeture.invalid? # should be invalid if no attributes
  end

end
