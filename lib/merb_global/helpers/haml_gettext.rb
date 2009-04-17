module Merb
  module Global
    module Helpers
      module HamlGettext
        # Inject _ gettext into plain text and tag plain text calls
        def push_plain(text)
          if text =~ /JOIN THE/
            Merb.logger.debug("push plain for #{text}")
          end
          super(_(text.strip))
        end
        def parse_tag(line)
          tag_name, attributes, attributes_hash, object_ref, nuke_outer_whitespace,
            nuke_inner_whitespace, action, value = super(line)
          value = _(value) unless action || value.empty?
          [tag_name, attributes, attributes_hash, object_ref, nuke_outer_whitespace,
              nuke_inner_whitespace, action, value]
        end
      end
    end
  end
end

Haml::Engine.send(:include, Merb::Global::Helpers::HamlGettext) 
Haml::Engine.send(:include, Merb::Global)