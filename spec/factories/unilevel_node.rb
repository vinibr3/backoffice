FactoryBot.define do
  factory :unilevel_node do
    user { association(:user) }
    sponsored { association(:user) }
  end
end
