import React from 'react'
import PropTypes from 'prop-types'
import humanizeList from 'humanize-list'

const WhichWeWillRecordUsingSentence = (props) => {
  let recordingMethodsSentence = ''

  if (props.recording_methods) {
    const recordingMethodLabels =
      props.recording_methods.map((method) => props.all_recording_methods[method])
    recordingMethodsSentence = humanizeList(
      recordingMethodLabels, { oxfordComma: true }
    )
  }

  const childsIfUnable = props.able_to_consent ? '' : ' childʼs'

  return (
    <li>
      I understand that my{childsIfUnable} activities during the research session may
      be observed and will be recorded. The data captured, in the form of{' '}
      <output className="reactive-preview__highlight">{recordingMethodsSentence}</output>
      {' '}will be used for current and future service development.
    </li>
  )
}

WhichWeWillRecordUsingSentence.propTypes = {
  recording_methods: PropTypes.array,
  all_recording_methods: PropTypes.object,
  able_to_consent: PropTypes.bool
}

export default WhichWeWillRecordUsingSentence
