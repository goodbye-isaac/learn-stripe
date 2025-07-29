class Customer::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :endpoint_secret)
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      p e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      p e
      status 400
      return
    end

    case enent.type
    when "checkout.session.completed"
      # ... execute a process
    end
  end
end
