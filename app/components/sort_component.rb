class SortComponent < ActionView::Component::Base
  # validates :content, presence: true

  def initialize(options:, value:)
    @options = options
    @value = value
  end

  private

  attr_reader :options
  attr_reader :value
end
