module ResearchSessionsHelper
  def dynamic(text)
    content_tag :span, class: 'highlight' do
      text
    end
  end
end
