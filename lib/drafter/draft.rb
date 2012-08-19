# A model to store serialized draft data. Drafts attach themselves
# polymorphically to any other ActiveRecord class, loop through the
# target draftable classes's attributes, and store them as a Hash
# in the :data text field in the database.
#
# Drafts can also keep track of the target draftable's CarrierWave uploads,
# if any exist.
#
class Draft < ActiveRecord::Base

	# Validations
	#
	validates_presence_of :data

	# Associations
	#
  has_many :draft_uploads
	belongs_to :draftable, :polymorphic => true


	# Store serialized data for the associated draftable as a Hash of
  # attributes.
	#
  serialize :data, Hash

  # Approve a draft, setting the attributes of the draftable object to
  # contain the draft content, saving the draftable, and destroying the draft.
  #
  def approve!
  	draftable = build_draftable
  	draftable.save!
  	self.destroy
  	draftable
  end

  # Set things up so we can use dot notation to access draft data, e.g.
  # we can do either @foo.draft.data["title"] or (more neatly) we can
  # do @foo.draft.title
  #
  def method_missing(meth, *args, &block)
    if self.data.keys.include?(meth.to_s)
      self.data[meth.to_s]
    else
      super
    end
  end

  # Find the existing draftable, or build a new one, and set it up.
  #
	# @return the existing draftable object, or a new one of the proper
	# 	type, with attributes and files hanging off it.
	def build_draftable
    draftabl = draftable.nil? ? self.draftable_type.constantize.new(:draft => self) : draftable
    draftabl.apply_draft
    draftabl
	end

end
