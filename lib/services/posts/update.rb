module Services
  module Posts
    class Update
      attr_reader :errors, :updated_object

      def initialize(params, object)
        @params = params
        @updated_object = object
      end

      def call
        begin
          @updated_object.update!(@params)
          @success = true
        rescue
          @success = false
          @errors = @updated_object.errors.full_messages
        end
      end

      def success?
        @success
      end
    end
  end
end