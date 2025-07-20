module Components::ProgressHelper
  def render_progress(value:, color: nil)
    value = (100 - value)
    class_color = value < 0 ? "bg-red-500" : (color.nil? ? "bg-gray-400" : "")
    color = nil if value < 0
    render "components/ui/progress", value: value, class_color: class_color, color: color
  end
end
