require "tailwind_merge"

module ComponentsHelper
  def tw(*classes)
    TailwindMerge::Merger.new.merge(classes.join(" "))
  end

  PRIMARY_CLASSES = " border-transparent bg-blue-900 text-gray-100 hover:bg-blue-800 "
  SECONDARY_CLASSES = " border-transparent bg-gray-900 text-gray-100  hover:bg-gray-800 "
  OUTLINE_CLASSES = "  border border-input bg-background hover:bg-accent hover:text-accent-foreground "
  GHOST_CLASSES = " hover:bg-accent hover:text-accent-foreground  "
  DESTRUCTIVE_CLASSES = " bg-destructive text-destructive-foreground hover:bg-destructive/90 "

  module Button
    PRIMARY = ComponentsHelper::PRIMARY_CLASSES
    SECONDARY = ComponentsHelper::SECONDARY_CLASSES
    OUTLINE = ComponentsHelper::OUTLINE_CLASSES
    GHOST = ComponentsHelper::GHOST_CLASSES
    DESTRUCTIVE = ComponentsHelper::DESTRUCTIVE_CLASSES
  end

  module Alert
  end
end
