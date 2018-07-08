module Services
  module Posts
    class List
      attr_reader :objects_list, :current_page

      def initialize(page, user_id)
        @current_page = page.to_i
        @per_page = 10
        @user_id = user_id
      end

      def call
        @objects_list ||= Post.where(draft: false).or(Post.user_drafts(@user_id)).order(created_at: :desc).paginate(page: @current_page, per_page: @per_page).to_a
        self
      end

      def more?
        @more ||= ((Post.count / @per_page) - @current_page).positive?
      end
    end
  end
end