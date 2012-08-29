module Diffing

  # Get a diff between the current and draft status of an ActiveRecord
  # object field.
  #
  # @param [Symbol] attr the attribute you want to diff.
  # @param [Hash] options an options hash allowing you to pass a :format.
  # @return [String] a diff string. If :format was nil, this could be a
  #   [Diffy::Diff].
  def differences(attr, options={:format => :html})
    if self.draft
      Diffy::Diff.new(self.send(attr), self.draft(attr)).to_s(options[:format])
    end
  end

end