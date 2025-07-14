class CardComponent < Phlex::HTML
  def initialize(class: nil, **attrs)
    @class = binding.local_variable_get(:class)
    @attrs = attrs
  end

  def view_template(&block)
    div(
      class: [
        "rounded-lg bg-card text-card-foreground shadow-xl border border-gray-200x",
        @class
      ].compact.join(" "),
      **@attrs,
      &block
    )
  end

  VARIANTS = {
    default: "flex flex-col space-y-1.5 p-6",
    custom: " space-y-1.5 p-6"
  }

  class Header < Phlex::HTML
    def initialize(variant: :default, class: nil, **attrs)
      @variant = variant
      @class = binding.local_variable_get(:class)
      @attrs = attrs
    end

    def view_template(&block)
      div(
        class: [VARIANTS[@variant], @class].compact.join(" "),
        **@attrs,
        &block
      )
    end
  end

  class Title < Phlex::HTML
    def initialize(class: nil, **attrs)
      @class = binding.local_variable_get(:class)
      @attrs = attrs
    end

    def view_template(&block)
      h3(
        class: [
          "text-2xl font-semibold leading-none tracking-tight",
          @class
        ].compact.join(" "),
        **@attrs,
        &block
      )
    end
  end

  class Description < Phlex::HTML
    def initialize(class: nil, **attrs)
      @class = binding.local_variable_get(:class)
      @attrs = attrs
    end

    def view_template(&block)
      p(
        class: ["text-sm text-gray-500", @class].compact.join(" "),
        **@attrs,
        &block
      )
    end
  end

  class Content < Phlex::HTML
    def initialize(class: nil, **attrs)
      @class = binding.local_variable_get(:class)
      @attrs = attrs
    end

    def view_template(&block)
      div(
        class: ["p-6 pt-0", @class].compact.join(" "),
        **@attrs,
        &block
      )
    end
  end
end