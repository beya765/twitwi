require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                      followed_id: users(:archer).id)
  end

  test "Relationshipモデルが有効か" do
    assert @relationship.valid?
  end

  test "フォロワーIDが無いRelationモデルは有効か" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "フォローIDが無いRelationモデルは有効か" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
