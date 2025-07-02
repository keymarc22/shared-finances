module ApplicationHelper

  def to_money_format(amount)
    if amount.is_a?(Money)
      amount.format
    elsif amount.is_a?(Numeric)
      Money.new(amount).format
    else
      raise ArgumentError, "Amount must be a Numeric or Money object"
    end
  end

  def label_classes
    "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
  end

  def link_as_button_classes
    "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-white transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-750 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-gray-950 text-white hover:bg-gray-800 h-10 px-4 py-2"
  end

  def render_turbo_stream_flash_messages(layout = "layouts/alerts")
    turbo_stream.prepend "flash", partial: layout
  end
end
