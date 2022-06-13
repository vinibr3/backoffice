ActiveRecord::Base.transaction do
  SystemParametrization.create_default!

  root = User.root!
  user = User.network_head!
  unilevel_node = UnilevelNode.network_head!

  category = Category.create!(name: 'Adesão', code: 10, active: true)

  client = Profile.create!(name: 'Client',
                           trade_fee_percentage: 65,
                           duration_days_per_purchase: 365,
                           duration_days_per_monthly_result: 30,
                           monthly_qualification_amount: 0,
                           active: true)
  client_product = Product.create!(profile: client,
                                   category: category,
                                   price: 0,
                                   name: 'Client',
                                   active: true,
                                   code: 10)

 affiliate = Profile.create!(name: 'Affiliate Free',
                             trade_fee_percentage: 65,
                             duration_days_per_purchase: 365,
                             duration_days_per_monthly_result: 30,
                             monthly_qualification_amount: 0,
                             active: true)
 affiliate_product = Product.create!(profile: affiliate,
                                     category: category,
                                     price: 0,
                                     name: 'Affiliate Free',
                                     active: true,
                                     code: 20)

 executive = Profile.create!(name: 'Executive',
                             trade_fee_percentage: 60,
                             duration_days_per_purchase: 365,
                             duration_days_per_monthly_result: 30,
                             monthly_qualification_amount: 5000,
                             active: true)
 executive_product = Product.create!(profile: executive,
                                     category: category,
                                     price: 500,
                                     name: 'Executive',
                                     active: true,
                                     code: 30)

 prime = Profile.create!(name: 'Prime',
                         trade_fee_percentage: 55,
                         duration_days_per_purchase: 365,
                         duration_days_per_monthly_result: 30,
                         monthly_qualification_amount: 15000,
                         active: true)
 prime_product = Product.create!(profile: prime,
                                 category: category,
                                 price: 1000,
                                 name: 'Prime',
                                 active: true,
                                 code: 40)

 elite = Profile.create!(name: 'Elite',
                         trade_fee_percentage: 50,
                         duration_days_per_purchase: 365,
                         duration_days_per_monthly_result: 30,
                         monthly_qualification_amount: 25000,
                         active: true)
 elite_product = Product.create!(profile: elite,
                                 category: category,
                                 price: 2500,
                                 name: 'Elite',
                                 active: true,
                                 code: 50)

 premium = Profile.create!(name: 'Premium',
                         trade_fee_percentage: 35,
                         duration_days_per_purchase: 365,
                         duration_days_per_monthly_result: 30,
                         monthly_qualification_amount: 100000,
                         active: true)
 premium_product = Product.create!(profile: premium,
                                   category: category,
                                   price: 10000,
                                   name: 'Premium',
                                   active: true,
                                   code: 60)

 dollar = Currency.dollar

 bitcoin = Currency.create!(name: 'Bitcoin',
                            initials: Currency::INITIALS[:bitcoin],
                            scale: 8,
                            symbol: 'BTC',
                            crypto: true,
                            active: true,
                            order_payment_enabled: true,
                            deposit_payment_enabled: true,
                            withdraw_enabled: false,
                            receivable_method_enabled: true)

 ethereum = Currency.create!(name: 'Ethereum',
                             initials: Currency::INITIALS[:ethereum],
                             scale: 8,
                             symbol: 'ETH',
                             crypto: true,
                             active: true,
                             order_payment_enabled: true,
                             deposit_payment_enabled: true,
                             withdraw_enabled: false,
                             receivable_method_enabled: true)

 plisio_btc = PaymentMethod.create!(name: 'Plisio BTC',
                                    currency: bitcoin,
                                    active: true,
                                    code: PaymentMethod::VALID_CODES[:btc_plisio])

 plisio_eth = PaymentMethod.create!(name: 'Plisio ETH',
                                    currency: ethereum,
                                    active: true,
                                    code: PaymentMethod::VALID_CODES[:eth_plisio])
end
