class AlertComponent < Phlex::HTML
  BASE = "w-full p-6 card border rounded-sm relative".freeze

  TYPES_CONTAINER = {
    notice: "border-blue-200 bg-blue-200",
    warning: "border-amber-100 bg-amber-100",
    error: "border-b-red-300 bg-b-red-300"
  }

  TYPE_TEXT = {
    notice: "text-blue-600",
    warning: "text-amber-800",
    error: "text-red-800"
  }

  def initialize(type:, msg:)
    @type, @msg = type.to_sym, msg
  end

  def view_template
    div(
      class: "#{BASE} #{TYPES_CONTAINER[type]}",
      role: type,
      "data-controller": "removals", "data-action": "animationend->removals#remove"
    ) do
      h4 class: "font-semibold #{TYPE_TEXT[type]}" do
        I18n.t("alerts.#{type}")
      end

      p class: "d-flex justify-content-between #{TYPE_TEXT[type]}" do
        plain msg
      end

      a(href: "javascript:;", class: "absolute #{TYPE_TEXT[type]} cursor-pointer", style: "right: 14px; top: 7px", data: { action: "click->removals#remove" }) do
        "x"
      end
    end
  end

  private

  attr_reader :type, :msg
end
