import React from 'react'
import RecordingMethodsPreviews from './index.js'

describe('RecordingMethodsPreviews', () => {
  let props
  let mountedRecordingMethodsPreviews
  const recordingMethodsPreviews = () => {
    if (!mountedRecordingMethodsPreviews) {
      mountedRecordingMethodsPreviews = mount(
        <RecordingMethodsPreviews {...props} />
      )
    }
    return mountedRecordingMethodsPreviews
  }

  beforeEach(() => {
    props = {
      all_recording_methods: undefined,
      recording_methods: undefined,
      editLinks: {}
    }
    mountedRecordingMethodsPreviews = undefined
  })

  describe('the initial render state', () => {
    describe('no props are given', () => {
      it('renders as many sections as areas on the preview that could change', () => {
        const sections = recordingMethodsPreviews().find('section')
        expect(sections.length).to.eql(2)
      })

      it('has at least two outputs, all of which are blank', () => {
        const outputs = recordingMethodsPreviews().find('output')
        expect(outputs.length).to.be.greaterThan(1)
        outputs.forEach(output => expect(output.text()).to.be.empty)
      })
    })

    describe('three boxes are checked in the final preview', () => {
      beforeEach(() => {
        props = {
          all_recording_methods: {
            voice: 'voice recording',
            video: 'video recording',
            written: 'written notes',
            other: 'some other recording method'
          },
          recording_methods: ['voice', 'video', 'other'],
          other_recording_method: 'some other recording method',
          editLinks: {
            recording_methods: '/path/to/rails/recording_methods'
          },
          finalPreview: true
        }
        mountedRecordingMethodsPreviews = undefined
      })

      it('has a total of four outputs, three for bullet items and one for sentence', () => {
        const outputs = recordingMethodsPreviews().find('output')
        expect(outputs.length).to.eql(4)
      })

      it('has a li for items', () => {
        expect(recordingMethodsPreviews()).to.contain(
          <li>
            <output className="reactive-preview__highlight">
              <a className="editable" href="/path/to/rails/recording_methods">
                voice recording
              </a>
            </output>
          </li>
        )
      })

      it('has a li for the "other" item', () => {
        expect(recordingMethodsPreviews()).to.contain(
          <li>
            <output className="reactive-preview__highlight">
              <a className="editable" href="/path/to/rails/recording_methods">
                some other recording method
              </a>
            </output>
          </li>
        )
      })

      it('has a sentence with the checked items', () => {
        expect(recordingMethodsPreviews()).to.contain(
          <output className="reactive-preview__highlight">
            voice recording, video recording, and some other recording method
          </output>
        )
      })

      it('defaults to "my child"', () => {
        expect(recordingMethodsPreviews().text()).to.contain('I understand that my childʼs activities')
      })

      describe('able to give consent', () => {
        beforeEach(() => {
          props.able_to_consent = true
        })

        it('removes "my child"', () => {
          expect(recordingMethodsPreviews().text()).to.contain('I understand that my activities')
        })
      })
    })
  })
})
