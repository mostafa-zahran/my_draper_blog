module Presenters
  class Base

    def initialize(presenter, presented_value)
      @presenter = presenter
      @presented_value = presented_value
    end

    def result
      @result ||= @presented_value.is_a?(Array) ? present_collection : present_object
    end

    private

    def present_collection
      @presented_value.present? ? @presented_value.map{|obj| present(obj)} : []
    end

    def present_object
      @presented_value.present? ? present(@presented_value) : {}
    end

    def present(obj)
      @presenter.new(obj).present
    end
  end
end