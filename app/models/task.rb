class Task < ApplicationRecord
  class Task < ApplicationRecord
    validates :title, :content, :due_at, presence: true
    belongs_to :user
end
