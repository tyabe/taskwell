class Project < ActiveRecord::Base

  # Fields
  field :name,        as: :string
  field :description, as: :text
  field :token,       as: :string
  timestamps

  attr_accessible :name, :description

  # Validations
  validates_presence_of :name

  # Relations
  has_many :tasks

  before_create :generate_token

  private

  def generate_token
    loop do
      self.token = SecureRandom.hex
      break unless self.class.where(token: self.token).first
    end
  end

end
