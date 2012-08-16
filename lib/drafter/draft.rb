class Draft < ActiveRecord::Base

	belongs_to :draftable, :polymorphic => true

  serialize :data, Hash

end