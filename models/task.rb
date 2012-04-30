class Task < ActiveRecord::Base

  # Fields
  field :name, as: :string
  field :done, as: :boolean, default: false
  field :due_date, as: :date
  field :position, as: :integer

  attr_accessible :name, :done

  # Validations
  validates_presence_of :name

  # Relations
  belongs_to :project

  # scopes
  default_scope order('position asc', 'id asc')

end
