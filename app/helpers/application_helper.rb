module ApplicationHelper
  def label_classes
    "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
  end

  def render_turbo_stream_flash_messages(layout = "layouts/alerts")
    turbo_stream.prepend "flash", partial: layout
  end
end
