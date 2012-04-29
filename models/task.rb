class Task < ActiveRecord::Base

  # Fields
  field :name, as: :string
  field :done, as: :boolean, default: false
  field :due_date, as: :date

  # Validations
  validates_presence_of :name

end
