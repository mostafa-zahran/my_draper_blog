module Services
  module Posts
    class SendVerificationCode
      def initialize(code, phone)
        @code = code
        @phone = phone
      end

      def call
        Twilio::REST::Client.new.messages.create({
                                                     from: ENV['TWILLIO_PHONE_NUMBER_LIVE'],
                                                     to: @phone,
                                                     body: @code
                                                 })
      end
    end
  end
end