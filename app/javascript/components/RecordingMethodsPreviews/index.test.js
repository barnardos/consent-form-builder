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
            recording_methods: '/path/to/rails/recording_methods',
            other_recording_method: '/path/to/rails/recording_methods'
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
            <output>
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
            <output>
              <a className="editable" href="/path/to/rails/recording_methods">
                some other recording method
              </a>
            </output>
          </li>
        )
      })

      it('has a sentence with the checked items', () => {
        expect(recordingMethodsPreviews()).to.contain(
          <output>
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

  describe('values changing', () => {
    describe('the researcher name changing', () => {
      beforeEach(() => {
        props = {
          recording_methods: ['voice', 'another_thing'],
          other_recording_method: 'The other value',
          all_recording_methods: {
            'voice': 'the voice',
            'video': 'the video',
            'another_thing': 'another thing'
          }
        }
      })

      describe('adding an item that is not there', () => {
        // Simulate change from a field such as
        // <input name="research_session[recording_methods][]" data-previewed-by="RecordingMethodsPreviews" />
        // - usually triggered onchange, but that link is not tested here, we're just simulating the
        //   resulting event
        beforeEach(() => {
          recordingMethodsPreviews().instance().handleCheckboxChange({
            target: {
              name: 'research_session[recording_methods][]',
              value: 'video',
              checked: true
            }
          })
          recordingMethodsPreviews().update()
        })

        it('adds that value to the list in order', () => {
          expect(recordingMethodsPreviews()).to.contain(
            <ul className="bullet-point-list">
              <li><output className="reactive-preview__highlight">the voice</output></li>
              <li><output className="reactive-preview__highlight">the video</output></li>
              <li><output className="reactive-preview__highlight">another thing</output></li>
            </ul>
          )
        })

        it('adds that value to the sentence in order', () => {
          expect(recordingMethodsPreviews().text()).to.contain(
            'the voice, the video, and another thing'
          )
        })
      })

      describe('changing the "other" value', () => {
        // Simulate change from a field such as
        // <input name="research_session[other_recording_method]" data-previewed-by="RecordingMethodsPreviews" />
        // - usually triggered oninput, but that link is not tested here, we're just simulating the
        //   resulting event
        beforeEach(() => {
          props['recording_methods'] = ['voice', 'video', 'other']
          recordingMethodsPreviews().instance().handleTextChange({
            target: {
              name: 'research_session[other_recording_method]', value: 'a new other value'
            }
          })
          recordingMethodsPreviews().update()
        })

        it('changes the value in the list', () => {
          expect(recordingMethodsPreviews()).to.contain(
            <output className="reactive-preview__highlight">
              a new other value
            </output>
          )
        })

        it('changes the value in the sentence', () => {
          expect(recordingMethodsPreviews()).to.contain(
            <output className="reactive-preview__highlight">
              the voice, the video, and a new other value
            </output>
          )
        })
      })

      describe('removing an item that is there', () => {
        // Simulate change from a field such as
        // <input name="research_session[recording_methods][]" data-previewed-by="RecordingMethodsPreviews" />
        // - usually triggered onchange, but that link is not tested here, we're just simulating the
        //   resulting event

        it('removes that value from the list', () => {
          recordingMethodsPreviews().instance().handleCheckboxChange({
            target: {
              name: 'research_session[recording_methods][]',
              value: 'voice',
              checked: false
            }
          })

          expect(recordingMethodsPreviews().text()).not.to.contain('the voice')
        })
      })
    })
  })
})
