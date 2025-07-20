module Components::CardHelper
  def render_card(title: nil, subtitle: nil, body: nil, icon: nil, icon_classes: "p-5", footer: nil, **options, &block)
    render "components/ui/card", title: title, subtitle: subtitle, footer: footer, icon: icon, icon_classes: icon_classes, body: (block ? capture(&block) : body), block:, options: options
  end
end
