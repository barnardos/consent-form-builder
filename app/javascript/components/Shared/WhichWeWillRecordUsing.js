import React from 'react'
import PropTypes from 'prop-types'
import Output from './Output'

const WhichWeWillRecordUsing = (props) => {
  let listItems

  if (props.recording_methods) {
    listItems =
      props.recording_methods.map((method) => {
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

WhichWeWillRecordUsing.propTypes = {
  recording_methods: PropTypes.array,
  all_recording_methods: PropTypes.object
}

export default WhichWeWillRecordUsing
