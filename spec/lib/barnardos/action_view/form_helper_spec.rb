require 'rails_helper'

RSpec.describe Barnardos::ActionView::FormHelper, type: :helper do
  include RSpecHtmlMatchers

  describe '#barnardos_form_with' do
    subject(:rendered) { helper.barnardos_form_with model: ResearchSession.new, url: 'custom' }

    it 'looks just like another form' do
      expect(rendered).to have_tag('form[action=custom]')
    end
  end
end
