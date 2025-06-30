class ButtonComponent < Phlex::HTML
  include Phlex::Rails::Helpers::ContentFor

  VARIANTS = {
    default: "bg-gray-900 text-gray-50 hover:bg-gray-900/90",
    destructive: "bg-red-500 text-gray-50 hover:bg-red-500/90",
    outline: "border border-gray-200 bg-white hover:bg-gray-100 hover:text-gray-900",
    secondary: "bg-gray-100 text-gray-900 hover:bg-gray-100/80",
    ghost: "hover:bg-gray-100 hover:text-gray-900",
    link: "text-gray-900 underline-offset-4 hover:underline",
    primary: "bg-gray-950 text-white hover:bg-gray-800",
    pill: "flex-1 text-center px-4 py-2 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-300 transition-colors duration-200 ease-in-out whitespace-nowrap sm:text-base md:px-6 md:py-3"
  }.freeze

  SIZES = {
    default: "h-10 px-4 py-2",
    sm: "h-9 rounded-md px-3",
    lg: "h-11 rounded-md px-8",
    icon: "h-10 w-10"
  }.freeze

  def initialize(variant: :default, size: :default, class: nil, **attrs)
    @variant = variant
    @size = size
    @class = binding.local_variable_get(:class)
    @attrs = attrs
  end

  def view_template(&block)
    button(
      type: "button",
      class: [
        "cursor-pointer inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-white transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-750 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
        VARIANTS[@variant],
        SIZES[@size],
        @class
      ].compact.join(" "),
      **@attrs,
      &block
    )
  end
end
