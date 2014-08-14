# encoding: utf-8

module Cql
  module Statements
    # Batch statement groups several {Cql::Statement}. There are several types of Batch statements available:
    # @see Cql::Session#batch
    # @see Cql::Session#logged_batch
    # @see Cql::Session#unlogged_batch
    # @see Cql::Session#counter_batch
    class Batch
      # @private
      class Logged < Batch
        def type
          :logged
        end
      end

      # @private
      class Unlogged < Batch
        def type
          :unlogged
        end
      end

      # @private
      class Counter < Batch
        def type
          :counter
        end
      end

      include Statement

      # @private
      attr_reader :statements

      # @private
      def initialize
        @statements = []
      end

      # Adds a statement to this batch
      # @param statement [String, Cql::Statements::Simple,
      #   Cql::Statements::Prepared, Cql::Statements::Bound] statement to add
      # @param args [*Object] arguments to paramterized query or prepared
      #   statement
      # @return [self]
      def add(statement, *args)
        case statement
        when String
          @statements << Simple.new(statement, *args)
        when Prepared
          @statements << statement.bind(*args)
        when Bound, Simple
          @statements << statement
        else
          raise ::ArgumentError, "a batch can only consist of simple or prepared statements, #{statement.inspect} given"
        end

        self
      end

      # A batch statement doesn't really have any cql of its own as it is composed of multiple different statements
      # @return [nil] nothing
      def cql
        nil
      end

      # @return [Symbol] one of `:logged`, `:unlogged` or `:counter`
      def type
      end
    end
  end
end
