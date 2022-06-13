class PaymentTransactions::PayerService < ApplicationService
  def call
    ActiveRecord::Base.transaction do
      pays_payment_transaction
      assigns_profile_of_order_user if @payable.is_a?(Order)
      increments_company_balance if @payable.is_a?(Order)
      creates_order_bonus if @payable.is_a?(Order)
      adds_deposit_amount_to_user_balance if @payable.is_a?(Deposit)

      @payment_transaction
    end
  rescue StandardError => error
    register_notification_error(error.message)

    raise error.message
  end

  private

  def initialize(args)
    @notification = args[:notification]
    @transaction_code = @notification[:transaction_code]
    @payment_transaction = PaymentTransaction.unpaid
                                             .includes(payable: [:user])
                                             .find_by!(transaction_code: @transaction_code)
    @user = @payment_transaction.payable.user
    @payable = @payment_transaction.payable
  end

  def pays_payment_transaction
    @payment_transaction.update!(paid_at: Time.now,
                                 status: :paid,
                                 notification_response: @notification)
  end

  def assigns_profile_of_order_user
    profile = @payment_transaction.payable.products.detect(&:profile).try(:profile)

    Users::UserProfiles::CreatorService.call(user: @user, profile: profile)
  end

  def increments_company_balance
    @user.financial_transactions
         .create!(spreader_user: @user,
                  order: @payable,
                  financial_reason: FinancialReason.order_payment,
                  currency: @payable.currency,
                  bonus_commission: nil,
                  note: '',
                  user_amount: 0,
                  user_cashflow: :not_applicable,
                  admin_amount: @payable.total,
                  admin_cashflow: :in,
                  system_amount: 0,
                  system_cashflow: :not_applicable)
  end

  def creates_order_bonus
    order = @payment_transaction.payable

    FinancialTransactions::DirectIndicationCreatorService.call(order: order)
    FinancialTransactions::IndirectIndicationCreatorService.call(order: order)
  end

  def adds_deposit_amount_to_user_balance
    @user.financial_transactions
         .create!(financial_reason: FinancialReason.deposit,
                  deposit: @payable,
                  currency: @payable.currency,
                  user_amount: @payable.amount,
                  user_cashflow: :in,
                  admin_cashflow: :not_applicable,
                  admin_amount: 0,
                  system_amount: 0,
                  system_cashflow: :not_applicable)
  end

  def register_notification_error(error_message)
    @payment_transaction.update!(notification_response: error_message)
  end
end
