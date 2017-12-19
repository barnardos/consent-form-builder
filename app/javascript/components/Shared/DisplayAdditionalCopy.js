import React from 'react'
import PropTypes from 'prop-types'

const DisplayAdditionalCopy = ({finalPreview, content}) => {
  return finalPreview ? content : <span>&hellip;</span>
}

DisplayAdditionalCopy.propTypes = {
  content: PropTypes.string,
  finalPreview: PropTypes.bool
}

export default DisplayAdditionalCopy
