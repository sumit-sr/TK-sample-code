# frozen_string_literal: true

# Calss for encoding and decoding secrets/digest

class SmsSender
  require 'twilio-ruby'
  twilio = Setting.where(slug: 'twilio', environment_id: Rails.env).first
  if twilio.present?
    EXPIRED_IN = twilio.preferences[:expired_in].hours
    FROM = twilio.preferences[:account_no]
    TWILIO_SID = twilio.preferences[:account_sid]
    TWILIO_TOKEN = twilio.preferences[:auth_token]
  else
    EXPIRED_IN = AppConfig['twilio']['expired_in'].hours
    FROM = AppConfig['twilio']['account_no']
    TWILIO_SID = AppConfig['twilio']['account_sid']
    TWILIO_TOKEN = AppConfig['twilio']['auth_token']
  end

  def self.send_otp(detail)
    set_client.api.account.messages.create(
      from: FROM,
      to: "+#{detail.value}",
      body: "Hello, your verification code for Taskina is: #{detail.otp}, valid for next #{EXPIRED_IN} seconds only!"
    )
  end
  # Body content will be changed as per requirement, or will save this in DB as well with other details

  def self.send_reset_password_otp(detail:, otp:)
    set_client.api.account.messages.create(
      from: FROM,
      to: "+#{detail.value}",
      body: "Hello, your reset password OTP for Taskina is: #{otp}, valid for next #{AppConfig['reset_password_otp']['expired_in_hours']} only."
    )
  end

  def self.send_notification(detail)
    set_client.api.account.messages.create(
      from: FROM,
      to: "+#{detail.connection&.connection_detail&.value}",
      body: detail.content
    )
  end

  # set up a client to talk to the Twilio REST API
  def self.set_client
    Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN
  end
end
