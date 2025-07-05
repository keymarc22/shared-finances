class ProgressComponent < Phlex::HTML
  def initialize(value:, max: 100, class: nil, **attrs)
    @value = value
    @max = max
    @class = binding.local_variable_get(:class)
    @attrs = attrs
  end

  def view_template
    div(
      class: [
        "relative h-4 w-full overflow-hidden rounded-full bg-gray-200",
        @class
      ].compact.join(" "),
      **@attrs
    ) do
      div(
        class: "h-full bg-blue-600 transition-all duration-300 ease-in-out",
        style: "width: #{@value.to_i}px"
      )
    end
  end
end
