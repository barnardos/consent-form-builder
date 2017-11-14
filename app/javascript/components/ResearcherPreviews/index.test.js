import React from 'react'
import { mount, configure } from 'enzyme'
import Adapter from 'enzyme-adapter-react-16'
import chai from 'chai'
import ResearcherPreviews from './index.js'

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
        expect(researcherPreviews().text()).to.contain(`${props.researcher_name}, ${props.researcher_job_title}, is the researcher who will be leading the session.`)
      })
      it("renders the researcher's contact details in a readable sentence", () => {
        expect(researcherPreviews().text()).to.contain(`${props.researcher_name} can be contacted by email at ${props.researcher_email} or by telephone on ${props.researcher_phone}`)
      })
    })
  })
})
