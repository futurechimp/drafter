class Draft < ActiveRecord::Base

	belongs_to :draftable, :polymorphic => true

end