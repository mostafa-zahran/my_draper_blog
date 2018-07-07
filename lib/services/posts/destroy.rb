module Services
  module Posts
    class Destroy
      attr_reader :errors, :destroyed_object

      def initialize(destroyed_object)
        @destroyed_object = destroyed_object
      end

      def call
        begin
          @destroyed_object.destroy!
          @success = true
        rescue
          @success = false
          @errors = @destroyed_object.errors.full_messages
        end
        self
      end

      def success?
        @success
      end
    end
  end
end