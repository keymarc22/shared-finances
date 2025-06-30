class BadgeComponent < Phlex::HTML
  VARIANTS = {
    default: "border-transparent bg-gray-900 text-gray-50 hover:bg-gray-900/80",
    secondary: "border-transparent bg-gray-100 text-gray-900 hover:bg-gray-100/80",
    destructive: "border-transparent bg-red-500 text-gray-50 hover:bg-red-500/80",
    outline: "text-gray-950 border-gray-200"
  }.freeze

  def initialize(variant: :default, class: nil, **attrs)
    @variant = variant
    @class = binding.local_variable_get(:class)
    @attrs = attrs
  end

  def view_template(&block)
    span(
      class: [
        "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-gray-950 focus:ring-offset-2",
        VARIANTS[@variant],
        @class
      ].compact.join(" "),
      **@attrs,
      &block
    )
  end
end
