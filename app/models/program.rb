class Program < ApplicationRecord
    has_many :days, dependent: :destroy

end
