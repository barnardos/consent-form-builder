import React from 'react'
import PropTypes from 'prop-types'
import Output from './Output'
import sortAgainst from './sort-against'

const WhichWeWillRecordUsingList = (props) => {
  let listItems

  if (props.recording_methods) {
    const sortedRecordingMethods = sortAgainst(props.recording_methods, props.all_recording_methods)
    listItems =
      sortedRecordingMethods.map((method) => {
        if (method === 'other') {
          return (
            <li key={method}>
              {Output(props, 'other_recording_method')}
            </li>
          )
        }

        return (
          <li key={method}>
            {Output(props, 'recording_methods', props.all_recording_methods[method])}
          </li>
        )
      })
  } else {
    listItems = <li><output className='reactive-preview__highlight' /></li>
  }

  return (
    <span>
      <p>
        Which we will record using:
      </p>
      <ul className="bullet-point-list">
        {listItems}
      </ul>
    </span>
  )
}

WhichWeWillRecordUsingList.propTypes = {
  recording_methods: PropTypes.array,
  all_recording_methods: PropTypes.object,
  other_recording_method: PropTypes.string
}

export default WhichWeWillRecordUsingList
