# frozen_string_literal: true

module ApplicationHelper
  def page_title(title = '')
    base_title = 'Praise-Diary'
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end
