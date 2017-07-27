module ResearchSessionsHelper
  def highlight(text)
    content_tag :strong, class: 'highlight' do
      text
    end
  end
end
