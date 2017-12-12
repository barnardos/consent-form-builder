import React from 'react'
import PropTypes from 'prop-types'
import PreviewBase from '../Shared/PreviewBase'
import FindOutMore from '../Shared/FindOutMore'
import WhatHappensInThisResearchSession from '../Shared/WhatHappensInThisResearchSession'

class ResearcherPreviews extends PreviewBase {
  componentName () {
    return 'ResearcherPreviews'
  }

  render () {
    return (
      <div>
        <WhatHappensInThisResearchSession {...this.state} />
        <FindOutMore {...this.state} />
      </div>
    )
  }
}

ResearcherPreviews.propTypes = {
  researcher_job_title: PropTypes.string,
  researcher_name: PropTypes.string,
  researcher_email: PropTypes.string,
  researcher_phone: PropTypes.string,
  finalPreview: PropTypes.bool
}

ResearcherPreviews.defaultProps = {
  finalPreview: false
}

export default ResearcherPreviews
