module OrdersHelper
  def render_payment_service_button(order, type)

    payment_service_for order,
      order.email,
      service: :allpay,
      html: { authenticity_token: false, enforce_utf8: false, method: :post } do |service|

      service.merchant_trade_no   "#{order.id}s#{Time.now.strftime("%Y%m%d%H%M%S")}"
      service.merchant_trade_date order.created_at
      service.total_amount        order.amount
      service.trade_desc          "order_sample"
      service.item_name           "order_sample"
      service.choose_payment      type_payment(type)
      service.client_back_url     root_url
      service.return_url          notify_order_url(order)
      service.encrypted_data

      submit_tag type_message(type), name: nil ,  style: "background-color: yellow;color: black"
    end
  end

  private

  def type_message(type)
    case type
    when "credit_card"
      "立即付款"
    when "cvs"
      "超商付款"
    when "atm"
      "ATM 付款"
    end
  end

  def type_payment(type)
    case type
    when "credit_card"
      ActiveMerchant::Billing::Integrations::Allpay::PAYMENT_CREDIT_CARD
    when "cvs"
      ActiveMerchant::Billing::Integrations::Allpay::PAYMENT_CVS
    when "atm"
      ActiveMerchant::Billing::Integrations::Allpay::PAYMENT_ATM
    end
  end
end