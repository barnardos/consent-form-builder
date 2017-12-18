import React from 'react'
import ResearcherPreviews from './index.js'

describe('ResearcherPreviews', () => {
  let props
  let mountedResearcherPreviews
  const researcherPreviews = () => {
    if (!mountedResearcherPreviews) {
      mountedResearcherPreviews = mount(
        <ResearcherPreviews {...props} />
      )
    }
    return mountedResearcherPreviews
  }

  beforeEach(() => {
    props = {
      researcher_job_title: undefined,
      researcher_name: undefined,
      researcher_email: undefined,
      researcher_other_name: undefined,
      you_or_your_child: undefined,
      edit_links: {}
    }
    mountedResearcherPreviews = undefined
  })

  describe('the initial render state', () => {
    describe('no props are given', () => {
      it('renders as many sections as areas on the preview that could change', () => {
        const sections = researcherPreviews().find('section')
        expect(sections.length).to.eql(2)
      })

      it('does not render the other researcher', () => {
        expect(researcherPreviews().text()).not.to.contain('colleagues')
      })

      it('has blank outputs', () => {
        researcherPreviews().find('output').forEach(output => expect(output.text()).to.be.empty)
      })
    })

    describe('props for the finalPreview are given', () => {
      beforeEach(() => {
        props = {
          finalPreview: true,
          researcher_job_title: 'Director of Research',
          researcher_name: 'Rachael Researcher',
          researcher_email: 'rachael.researcher@barnardos.org.uk',
          researcher_phone: '07123456789',
          you_or_your_child: 'you',
          editLinks: {
            researcher_name: '/rails/path/to/researcher_name',
            researcher_job_title: '/rails/path/to/researcher_job_title'
          }
        }
      })

      it("renders the researcher's job title and name in a readable sentence", () => {
        expect(researcherPreviews().text()).to.contain(
          `${props.researcher_name}, ${props.researcher_job_title},` +
          ` would like you to take part in`
        )
      })
      it('renders an editLink with the supplied rails route for the name', () => {
        expect(researcherPreviews()).to.contain(
          <output data-field="researcher_name">
            <a className="editable" href="/rails/path/to/researcher_name">Rachael Researcher</a>
          </output>
        )
      })
      it('renders an editLink with the supplied rails route for the job title', () => {
        expect(researcherPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/researcher_job_title">Director of Research</a>
        )
      })
      it("renders the researcher's contact details in a definition list", () => {
        expect(researcherPreviews().text()).to.contain(
          `Email:${props.researcher_email}`
        )
        expect(researcherPreviews().text()).to.contain(
          `Telephone:${props.researcher_phone}`
        )
      })
    })
  })

  describe('values changing', () => {
    describe('the researcher name changing', () => {
      beforeEach(() => {
        props = {
          researcher_name: 'Rachel'
        }
      })

      describe('receipt of an input change', () => {
        // Simulate change from a field such as
        // <input name="research_session[researcher_name]" data-previewed-by="ResearcherPreviews" />
        // - usually triggered oninput, but that link is not tested here, we're just simulating the
        //   resulting event

        it('changes the researcher name', () => {
          researcherPreviews().instance().handleTextOrRadioChange({
            target: { name: 'research_session[researcher_name]', value: 'Leanne' }
          })

          expect(researcherPreviews().find('output').first().text()).to.eql('Leanne')
        })
      })
    })
  })
})
