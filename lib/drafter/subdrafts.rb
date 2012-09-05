module Subdrafts

  private

    def create_subdrafts
      relations = self.class.saves_subdrafts_for
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
          object.save_draft(self.draft, relation)
        end
      end
    end

end