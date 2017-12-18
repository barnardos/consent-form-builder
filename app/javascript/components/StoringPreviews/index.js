import React from 'react'
import PropTypes from 'prop-types'
import PreviewBase from '../Shared/PreviewBase'
import WillAnyoneKnowWhatISayInTheDiscussion from '../Shared/WillAnyoneKnowWhatISayInTheDiscussion'

class StoringPreviews extends PreviewBase {
  componentName () {
    return 'StoringPreviews'
  }

  render () {
    return (
      <div>
        <WillAnyoneKnowWhatISayInTheDiscussion {...this.state } />
      </div>
    )
  }
}

StoringPreviews.propTypes = {
  shared_duration: PropTypes.string
}

export default StoringPreviews
