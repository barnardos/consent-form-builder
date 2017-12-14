import React from 'react'
import PropTypes from 'prop-types'
import PreviewBase from '../Shared/PreviewBase'
import WhichWeWillRecordUsing from '../Shared/WhichWeWillRecordUsingList'
import WhichWeWillRecordUsingSentence from '../Shared/WhichWeWillRecordUsingSentence'

class RecordingMethodsPreviews extends PreviewBase {
  componentName () {
    return 'RecordingMethodsPreviews'
  }

  render () {
    return (
      <div className="reactive-container__preview">
        <section className='reactive-preview__section'>
          <h3 className="reactive-preview__heading" id="what">What happens in this research session?</h3>
          <p>&hellip;</p>
          <WhichWeWillRecordUsing {...this.state } />
          <p>&hellip;</p>
        </section>
        <section className='reactive-preview__section'>
          <h3 className="reactive-preview__heading" id="consent-form">Consent Form</h3>
          <ul className="bullet-point-list">
            <li>&hellip;</li>
            <WhichWeWillRecordUsingSentence {...this.state} />
            <li>&hellip;</li>
          </ul>
        </section>
      </div>
    )
  }
}

RecordingMethodsPreviews.propTypes = {
  all_recording_methods: PropTypes.object,
  selected_recording_methods: PropTypes.array
}

export default RecordingMethodsPreviews
