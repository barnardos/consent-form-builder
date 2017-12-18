import React from 'react'
import StoringPreviews from './index.js'

describe('StoringPreviews', () => {
  let props
  let mountedStoringPreviews
  const storingPreviews = () => {
    if (!mountedStoringPreviews) {
      mountedStoringPreviews = mount(
        <StoringPreviews {...props} />
      )
    }
    return mountedStoringPreviews
  }

  beforeEach(() => {
    props = {
      shared_duration: undefined
    }
    mountedStoringPreviews = undefined
  })

  describe('the initial render state', () => {
    describe('no props are given', () => {
      it('renders a section as an area on the preview that could change', () => {
        const sections = storingPreviews().find('section')
        expect(sections.length).to.eql(1)
      })

      it('has two outputs, which are blank', () => {
        const outputs = storingPreviews().find('output')
        expect(outputs.length).to.equal(2)
        outputs.forEach(output => expect(output.text()).to.be.empty)
      })
    })

    describe('a radio button is selected and a year has been added', () => {
      beforeEach(() => {
        props = {
          shared_duration: 'one year',
          editLinks: {
            shared_duration: '/path/to/rails/storing'
          },
          finalPreview: true
        }
        mountedStoringPreviews = undefined
      })

      it('has a total of two outputs, both are sentences', () => {
        const outputs = storingPreviews().find('output')
        expect(outputs.length).to.eql(2)
      })

      it('has an output for shared_duration', () => {
        expect(storingPreviews()).to.contain(
          <output data-field="shared_duration">
            <a className="editable" href="/path/to/rails/storing">
              one year
            </a>
          </output>
        )
      })
    })
  })

  describe('values changing', () => {
    beforeEach(() => {
      props = {
        shared_duration: 'one year'
      }
    })

    describe('receipt of an input change', () => {
      it('changes the shared duration', () => {
        storingPreviews().instance().handleTextChange({
          target: { name: 'research_session[shared_duration]', value: 'two years' }
        })

        expect(storingPreviews().find('output[data-field="shared_duration"]').text()).to.eql('two years')
      })
    })
  })
})
