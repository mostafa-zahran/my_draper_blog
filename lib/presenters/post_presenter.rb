module Presenters
  class PostPresenter

    def initialize(post)
      @post = post
    end

    def present
      {id: @post.id, title: @post.title, short_description: @post.short_description, content: @post.content}
    end
  end
end