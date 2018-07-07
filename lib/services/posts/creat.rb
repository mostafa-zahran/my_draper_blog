module Services
  module Posts
    class Creat
      attr_reader :errors, :created_object

      def initialize(params)
        @params = params
      end

      def call
        begin
          @created_object = Post.create!(@params)
          @success = true
        rescue
          @success = false
          @errors = @created_object.errors.full_messages
        end
      end

      def success?
        @success
      end
    end
  end
end