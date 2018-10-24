require 'zettelkasten'

module Zettelkasten
  class Dynalist
    class Node
      extend Enumerable

      def self.each(include_root: false)
        return enum_for(:each) unless block_given?
        REGISTRY.each do |k, v|
          next if !include_root && v.root?
          yield v
        end
      end

      def self.load(json_data)
        kwargs = json_data.reduce({}) { |acc, (k, v)| acc[k.to_sym] = v; acc }
        new(**kwargs)
      end

      REGISTRY = {}

      attr_reader :id, :title, :note, :checked, :smol_guid
      def initialize(id:, content:, note:, checked:, children: [])
        @original_content = content

        REGISTRY[id] = self
        @id        = id

        if root?
          @smol_guid = nil
          @title     = content
        else
          smol_guid, title = content.split(' ', 2)
          @smol_guid = SmolGUID.parse(smol_guid)
          @title     = title
        end

        @note      = note
        @checked   = checked
        @child_ids = children
      end

      def content
        "#{@smol_guid} #{@title}"
      end

      def dirty?
        content != @original_content
      end

      def children
        REGISTRY.values_at(*@child_ids)
      end

      def root?
        @id == 'root'
      end
    end
  end
end
