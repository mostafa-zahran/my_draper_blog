module Verifiable
  extend ActiveSupport::Concern

  included do
    validates_presence_of :verification_code
    validates_uniqueness_of :verification_code
    before_create :generate_random_code
  end

  def generate_random_code
    new_code = SecureRandom.hex(10)
    until !self.class.where('LOWER(verification_code) = LOWER(?)', new_code).exists?
      new_code = SecureRandom.hex(3)
    end
    self.verification_code = new_code
  end
end