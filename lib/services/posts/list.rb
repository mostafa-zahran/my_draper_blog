module Services
  module Posts
    class List
      def call
        Post.all.to_a
      end
    end
  end
end