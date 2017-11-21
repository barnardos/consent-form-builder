/* eslint-disable no-unused-vars */
import React from 'react'
import ResearcherPreviews from './index.js'
/* eslint-enable no-unused-vars */
import { mount, configure } from 'enzyme'
import Adapter from 'enzyme-adapter-react-16'
import chai from 'chai'

configure({ adapter: new Adapter() })
const expect = chai.expect

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
      researcher_other_name: undefined
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

    describe('props are given', () => {
      beforeEach(() => {
        props = {
          researcher_job_title: 'Director of Research',
          researcher_name: 'Rachael Researcher',
          researcher_email: 'rachael.researcher@barnardos.org.uk',
          researcher_phone: '07123456789',
          researcher_other_name: 'Steve SecondaryResearcher'
        }
      })

      it("renders the researcher's job title and name in a readable sentence", () => {
        expect(researcherPreviews().text()).to.contain(
          `${props.researcher_name}, ${props.researcher_job_title}, ` +
          `is the researcher who will be leading the session.`
        )
      })
      it("renders the researcher's contact details in a readable sentence", () => {
        expect(researcherPreviews().text()).to.contain(
          `${props.researcher_name} can be contacted by email at ${props.researcher_email} ` +
          `or by telephone on ${props.researcher_phone}`
        )
      })
    })
  })

  describe('values changing', () => {
    describe('the researcher name changing', () => {
      beforeEach(() => {
        props = {
          researcher_name: 'Rachel',
          researcher_other_name: undefined
        }
      })

      describe('receipt of an input change', () => {
        // Simulate change from a field such as
        // <input name="research_session[researcher_name]" data-previewed-by="ResearcherPreviews" />
        // - usually triggered oninput, but that link is not tested here, we're just simulating the
        //   resulting event

        it('changes the researcher name', () => {
          researcherPreviews().instance().handleInputChange({
            target: { name: 'research_session[researcher_name]', value: 'Leanne' }
          })

          expect(researcherPreviews().find('output').first().text()).to.eql('Leanne')
        })

        it('changes the other researcher name', () => {
          researcherPreviews().instance().handleInputChange({
            target: { name: 'research_session[researcher_other_name]', value: 'Steve' }
          })

          expect(researcherPreviews().text()).to.include('Rachel\'s colleague, Steve')
        })
      })
    })
  })
})
