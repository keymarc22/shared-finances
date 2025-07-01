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

  def render_turbo_stream_flash_messages(layout = "layouts/alerts")
    turbo_stream.prepend "flash", partial: layout
  end
end
