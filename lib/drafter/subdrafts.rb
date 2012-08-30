module Subdrafts

  private

    def create_subdrafts
      relations = self.class.approves_drafts_for
      unless relations.empty?
        relations.each do |relation|
          create_subdrafts_for(relation)
        end
      end
    end

    def create_subdrafts_for(relation)
      objects = self.send(relation)
      unless objects.empty?
        objects.each do |object|
          create_subdraft_for(object, relation)
        end
      end
    end

    # TODO: this is too simple, we'll need to recursively save draft uploads again here.
    #
    def create_subdraft_for(object, relation)
      subdraft = Draft.new(:data => object.attributes, :parent_association_name => relation)
      self.draft.subdrafts << subdraft
    end

end