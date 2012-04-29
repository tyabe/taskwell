class Project < ActiveRecord::Base

  # Fields
  field :token, as: :string
  timestamps

  before_create :generate_token

  private

  def generate_token
    loop do
      self.token = SecureRandom.hex
      break unless self.class.where(token: self.token).first
    end
  end

end
