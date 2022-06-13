namespace :bonus_commissions do
  task populate_direct_indication: :environment do
    reason = FinancialReason.direct_indication
    products = Product.where(code: [20, 30, 40, 50, 60])
    GENERATIONS_COUNT = 1

    products.each do |product|
      GENERATIONS_COUNT.times do |index|
        next if reason.bonus_commissions
                      .exists?(generation: index + 1, product: product)

        reason.bonus_commissions
              .create!(generation: index + 1, percentage: 10.0, product: product)
      end
    end
  end

  task populate_indirect_indication: :environment do
    reason = FinancialReason.indirect_indication
    products = Product.where(code: [20, 30, 40, 50, 60])
    percentages_per_generation = { '2': 5,
                                   '3': 4,
                                   '4': 3,
                                   '5': 1}.with_indifferent_access

    products.each do |product|
      percentages_per_generation.each do |generation, percentage|
        next if reason.bonus_commissions
                      .exists?(generation: generation, product: product)

        reason.bonus_commissions
              .create!(generation: generation, percentage: percentage, product: product)
      end
    end
  end
end
