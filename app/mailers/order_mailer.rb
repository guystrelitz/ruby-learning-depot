class OrderMailer < ApplicationMailer

  default from: 'Sam Ruby <depot@example.com>'
  before_action :suppress_plus_minus_buttons

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end

  private

  def suppress_plus_minus_buttons
    @suppress_plus_minus_buttons = true
  end
end
