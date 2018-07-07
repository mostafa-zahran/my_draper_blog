module Services
  module Posts
    class Creat
      attr_reader :errors, :created_object

      def initialize(params)
        @params = params
      end

      def call
        @created_object = Post.new(@params)
        begin
          @created_object.save!
          @success = true
        rescue
          @success = false
          @errors = @created_object.errors.full_messages
        end
        self
      end

      def success?
        @success
      end
    end
  end
end