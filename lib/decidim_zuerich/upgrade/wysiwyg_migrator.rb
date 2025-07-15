module DecidimZuerich
  module Upgrade
    class WysiwygMigrator
      class << self
        def convert_list(list)
          parent = Nokogiri::XML::Node.new(list.name, doc)

          create_item = lambda do
            li = Nokogiri::XML::Node.new("li", doc)
            paragraph = Nokogiri::XML::Node.new("p", doc)
            li.add_child(paragraph)
            [li, paragraph]
          end
          add_empty_child = lambda do |child_parent|
            li, paragraph = create_item.call
            child_parent.add_child(li)
            [li, paragraph]
          end

          li = paragraph = nil
          current_parent = parent
          current_level = 0
          list.children.each do |item|
            next unless item.is_a?(Nokogiri::XML::Element) && item.name == "li"

            indent = detect_indent(item)
            if indent == current_level || li.nil?
              if item.child&.name == "p"
                # This content has already been migrated so we do not need to
                # re-migrate it.
                append_node(current_parent, convert_node(item))
                next
              else
                li, paragraph = add_empty_child.call(current_parent)
              end
            end

            while indent > current_level
              sublist = Nokogiri::XML::Node.new(list.name, doc)
              li.add_child(sublist)
              li, paragraph = create_item.call
              sublist.add_child(li)

              current_level += 1
              current_parent = sublist
            end
            while indent < current_level
              current_level -= 1
              li = current_parent.parent
              current_parent = li.parent
              paragraph = li.child

              li, paragraph = add_empty_child.call(current_parent) if indent == current_level
            end

            item.children.each { |child| append_node(paragraph, convert_node(child)) }
          end

          parent
        end
      end
    end
  end
end
