module Services
  module Posts
    class List
      attr_reader :objects_list, :current_page

      def initialize(page)
        @current_page = page.to_i
        @per_page = 10
      end

      def call
        @objects_list ||= Post.order(created_at: :desc).paginate(page: @current_page, per_page: @per_page).to_a
        self
      end

      def more?
        @more ||= ((Post.count / @per_page) - @current_page).positive?
      end
    end
  end
end