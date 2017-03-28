require 'test_helper'

class FermetureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

 test "should not save this without date" do
  	f = Fermeture.new
  	assert_not f.save
  end

end
