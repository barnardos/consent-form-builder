require 'rails_helper'

RSpec.describe ResearchSessionsHelper, :type => :helper do
  include RSpecHtmlMatchers

  describe '#highlight' do
    subject(:rendered) { helper.highlight('some text') }

    it 'wraps in a strong tag with correct class' do
      expect(rendered).to have_tag('strong.highlight', text: 'some text')
    end
  end
end
