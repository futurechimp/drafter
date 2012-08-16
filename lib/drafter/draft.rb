class Draft < ActiveRecord::Base

	validates_presence_of :data

	belongs_to :draftable, :polymorphic => true

  serialize :data, Hash

end