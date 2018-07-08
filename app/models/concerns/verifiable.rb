module Verifiable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_random_code, on: :create
    validates_presence_of :verification_code
    validates_uniqueness_of :verification_code
  end

  def generate_random_code
    new_code = SecureRandom.hex(10)
    until !self.class.where('LOWER(verification_code) = LOWER(?)', new_code).exists?
      new_code = SecureRandom.hex(10)
    end
    self.verification_code = new_code
  end
end