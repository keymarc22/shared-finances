SimpleForm.setup do |config|
  config.button_class = "bg-gray-950 text-white hover:bg-gray-800"

  config.wrappers :default, class: "grid gap-1 mb-6", hint_class: :field_with_hint, error_class: :field_with_errors, valid_class: :field_without_errors do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
    b.use :input,
          class: "mt-1 h-10 w-full rounded-md border border-gray-300 bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
          error_class: "is-invalid",
          valid_class: "is-valid"

    b.use :hint,  wrap_with: { tag: :span, class: :hint }
    b.use :full_error, wrap_with: { tag: :span, class: :error }
  end

  config.default_wrapper = :default
  config.boolean_style = :nested
  config.error_notification_tag = :div
  config.error_notification_class = "error_notification"
  config.browser_validations = false
  config.boolean_label_class = "checkbox"
end
