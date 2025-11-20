module Components::ProgressHelper
  def render_progress(value:, color: nil)
    value = (100 - value)
    render "components/ui/progress", value: value, color: color
  end
end
