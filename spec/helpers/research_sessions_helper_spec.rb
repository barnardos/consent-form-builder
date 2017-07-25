require 'rails_helper'

RSpec.describe ResearchSessionsHelper, :type => :helper do
  include RSpecHtmlMatchers

  describe '#dynamic' do
    subject(:rendered) { helper.dynamic('some text') }

    it 'wraps in a span' do
      expect(rendered).to have_tag('span.highlight', text: 'some text')
    end
  end
end
