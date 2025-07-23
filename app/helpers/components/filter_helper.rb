module Components::FilterHelper
  def filter_icon(&block)
    content_for :filter_icon, capture(&block), flush: true
  end

  def render_filter(items, **options, &block)
    content_for :filter_icon, "", flush: true
    content = capture(&block) if block
    input_class = content_for?(:filter_icon) ? "pl-1" : ""
    render "components/ui/filter", items: items, options: options, input_class: input_class, content: content
  end

  def list_item(value:, name:, selected:, action:, turbo_frame:, link:)
    classes = [
      "text-left cursor-pointer rounded transition-colors py-2 px-4",
      "hover:bg-gray-100",
      selected ? "bg-gray-200 font-semibold" : ""
    ].join(" ")

    link_to name,
      link,
      class: classes,
      "data-turbo-frame": turbo_frame,
      "data-action": action,
      "data-name": name,
      "data-value": value,
      "data-ui--filter-target": "item"
  end
end
