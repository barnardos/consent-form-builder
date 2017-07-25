module ResearchSessionsHelper
  def dynamic(text)
    content_tag :span, class: 'session-preview-element__highlighted' do
      text
    end
  end
end
