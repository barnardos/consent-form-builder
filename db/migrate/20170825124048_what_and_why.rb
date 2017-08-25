class WhatAndWhy < ActiveRecord::Migration[5.1]
  def change
    remove_column :research_sessions, :focus
    add_column :research_sessions, :topic, :text
    add_column :research_sessions, :purpose, :text
  end
end
