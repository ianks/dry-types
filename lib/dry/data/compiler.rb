module Dry
  module Data
    class Compiler
      attr_reader :types

      def initialize(types)
        @types = types
      end

      def call(ast)
        visit(ast)
      end

      def visit(node, *args)
        send(:"visit_#{node[0]}", node[1], *args)
      end

      def visit_type(node)
        type, args = node

        if args
          send(:"visit_#{type}", args)
        else
          types[type]
        end
      end

      def visit_hash(node)
        constructor, schema = node
        types['hash'].public_send(constructor, schema.map { |key| visit(key) }.reduce(:merge))
      end

      def visit_key(node)
        name, type = node
        { name => type }
      end
    end
  end
end
