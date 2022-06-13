module UnilevelNodeTree
  HEIGHT = 10

  def self.create(user = nil)
    user = user || FactoryBot.create(:user)

    root_user = FactoryBot.create(:user)
    root_node = FactoryBot.create(:unilevel_node, user: root_user, sponsored: user)

    nodes = [root_node]
    HEIGHT.times do
      nodes.map! { |n| n.children.create!(user: n.sponsored, sponsored: FactoryBot.create(:user)) }
    end
  end
end
