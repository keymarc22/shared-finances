module Components::AccordionHelper
  def accordion_title(&block)
    content_for :title, capture(&block), flush: true
  end

  def accordion_description(&block)
    content_for :description, capture(&block), flush: true
  end

  def render_accordion(container: nil, title: nil, description: nil, initial_state: "closed", &block)
    if title && !description
      content_for :description, capture(&block), flush: true
    elsif !title && !description
      capture(&block)
    end
    render "components/ui/accordion", title: title, description: description, container: container, initial_state: initial_state
  end
end
