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

  # Drafts are nestable, e.g. an Article's draft can have multiple
  # Comment drafts attached, and the whole thing can be approved at once.
  #
  belongs_to :parent, :class_name => "Draft"

  # Looked at from the other end, the parent draft should be able to address
  # its subdrafts.
  #
  has_many :subdrafts, :class_name => "Draft", :foreign_key => "parent_id", :dependent => :destroy # << test that

	# Store serialized data for the associated draftable as a Hash of
  # attributes.
	#
  serialize :data, Hash

  # Approve a draft, setting the attributes of the draftable object to
  # contain the draft content, saving the draftable, and destroying the draft.
  #
  def approve!
  	draftable = inflate
  	draftable.save!
  	self.destroy
  	draftable
  end

  # Reject the draft, basically destroying the draft object and leaving the
  # draftable unchanged.
  #
  def reject!
    self.destroy
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
	def inflate
    draftabl = draftable.nil? ? self.draftable_type.constantize.new(:draft => self) : draftable
    draftabl.draft = self # this should absolutely *not* be necessary, there's an STI bug in AR.
    draftabl.apply_draft
    draftabl
	end

  # It's possible to use the :delegate_approval_to => :foo option in the
  # draftable class method, so that this model can be approved as part of its
  # parent model. This method finds the 'approver', i.e. the Draft object which
  # is the parent object of this one and for which calling the 'approve' method
  # will approve this subdraft too.
  #
  # This is currently quite weak, in the sense that it'll screw up as soon
  # as you depart from standard AR class naming conventions. It's a good
  # target for future development, but I think at the moment, IAGNI.
  #
  # At the moment, we just return the parent if a delegate exists. This should
  # do the trick for us right now, as we're not using deeply nested object
  # graphs that need approvals. I've got the start of an alternate, somewhat
  # stronger implementation, underneath that, but we don't have time to do up
  # the general case right now.
  #
  # @return [Draft] approver the draft object which serves as the approval
  #   context for this one. Returns self or a delegated draft object.
  def approver
    delegate = self.inflate.class.delegate_approval_to
    if delegate
      parent
    else
      self
    end
  end
  #
  # Alternate implementation:
  # def approver
  #   if delegate.nil?
  #     self
  #   elsif delegate == self.parent.draftable_type.underscore.to_sym
  #     self.parent
  #   else
  #     For polymorphs, if we wanted to be really tight about things, we'd
  #     check here to see whether the inflated parent object has a has_many
  #     which matches this draft's parent_association_name, and if it does,
  #     and that association name matches up with the draftable's class name
  #     (or a :class_name specified in the relation), then we can conclude
  #     that the parent delegation is correct. It might look like:
      # if everything_matches_up <<<< do the code to match the previous paragraph
      #   parent
      # else
      #   raise "It is unclear what Draft object you're looking for. Please ensure
      #   that :delegate_approval_to => :foo points at a valid parent :foo"
      # end
    # end
  # end

end