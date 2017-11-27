# encoding: utf-8

require 'test_helper'

class EtudiantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "etudiant attributes must not be empty" do
    etudiant = Etudiant.new
    assert etudiant.invalid? # should be invalid if no attributes
    assert etudiant.errors[:nom].any? # nom must not be empty
    assert etudiant.errors[:formation_id].any? # etudiant must have a formation_id
  end
end
