module IdHash


  # Checks the state of the object to see whether it's an unapproved draft
  # (in which case it has no :id), or whether it's an approved object which
  # is being edited or updated (in which case we can address it by :id).
  #
  # This is primarily useful in your controllers. Sometimes, you might want to
  # identify the object by its :id; other times, you're dealing with an object
  # that only has a Draft but no actual object identity, in which case you'll
  # want to retrieve the Draft object by its :draft_id, and call
  # @draft.build_draftable on that.
  #
  # @return [Hash] a hash with either :draft_id => this object's draft's id,
  #   or :id => this object's id.
  def id_hash
    if !new_record?
      { :id => self.to_param }
    elsif new_record? && draft
      { :draft_id => draft.to_param }
    else
      raise "It's not clear what kind of id you're looking for."
    end
  end

  # When you're attaching sub-objects to a parent object, you'll sometimes need
  # to send the :id and :draft_id in another context, e.g. as :article_id and/or
  # :draft_article_id.
  #
  #
  # @param [Symbol] sym the symbol you want to inject into your id to provide
  #   context.
  # @return [Hash] a hash with e.g. :article_id or :draft_article_id, with the
  #   appropriate values set (as per id_hash above).
  def id_hash_as(sym)
    if !new_record?
      { "#{sym}_id".to_sym => self.to_param }
    elsif new_record? && draft
      { "draft_#{sym}_id".to_sym => draft.to_param }
    else
      raise "It's not clear what kind of id you're looking for."
    end
  end

end

