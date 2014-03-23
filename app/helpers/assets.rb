# Appends to and retrieves from declared assets stack.
#
# To include application assets and retrieve assets tags:
# <%= assets %>
#
# To include/display controller's assets:
# <%= assets 'controller/name' %>
#
# To append to assets stack on a per-view basis:
# # in layout:
# <%= assets 'controller/name' %>
#
# # in view:
#   <% assets 'controller/name/view' %> # note that helper output is ignored here, view asset tags
#                                       # are rendered in layout
#
def assets( filename = nil )
  @assets_stack ||= []
  filename = :application if @assets_stack.blank? && filename.blank?
  @assets_stack.unshift filename if filename.present?
  @assets_stack.map do |assets_filename|
    (stylesheet_tag assets_filename.to_s) +
    (javascript_tag assets_filename.to_s)
  end.join("\n")
end
