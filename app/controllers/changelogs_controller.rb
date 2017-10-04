require 'vandamme'

class ChangelogsController < ApplicationController
  def show
    @releases = parser.parse
  end

private

  def parser
    content = File.read(File.join(Rails.root, 'CHANGELOG.md'))
    @_parser ||= Vandamme::Parser.new(changelog: content, format: :md)
  end
end
