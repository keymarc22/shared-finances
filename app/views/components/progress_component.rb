class ProgressComponent < Phlex::HTML
  def initialize(value:, max: 100, class: nil, color: nil, **attrs)
    @value = value
    @max = max
    @class = binding.local_variable_get(:class)
    @attrs = attrs
    @color = value > 100 ? "red" : color
  end

  def view_template
    div(
      class: [
        "relative h-4 w-full overflow-hidden rounded-full #{@color ? '' : 'bg-gray-200'}",
        @class
      ].compact.join(" "),
      **@attrs
    ) do
      div(
        class: "h-full transition-all duration-300 ease-in-out",
        style: "width: #{calc_pixels}px; #{ @color ? "background-color: #{@color};" : '' }"
      )
    end
  end

  def calc_pixels
    [@value.to_i, 100].min
  end
end
