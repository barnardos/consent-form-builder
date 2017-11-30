import React from 'react'
import PropTypes from 'prop-types'
import Output from './Output'

const WhatHappensInThisResearchSession = (props) => {
  const colonOrEllipsis = props.methodologies_markup ? ':' : <span>&hellip;</span>
  let jobTitle = ''

  if (props.researcher_job_title) {
    jobTitle = <span>{', '}{Output(props, 'researcher_job_title')}{', '}</span>
  }

  return (
    <section className={ props.finalPreview ? '' : 'reactive-preview__section' }>
      <h3 className="subtitle-small" id="what">What happens in this research session?</h3>

      {Output(props, 'researcher_name')}
      {jobTitle} would like you to take part in
      {colonOrEllipsis}

      <div dangerouslySetInnerHTML={{__html: props.methodologies_markup}} />
      <div dangerouslySetInnerHTML={{__html: props.recording_markup}} />

      <p>
        There may be another researcher or observer supporting{' '}
        {Output(props, 'researcher_name')}.
      </p>
    </section>
  )
}

WhatHappensInThisResearchSession.propTypes = {
  researcher_name: PropTypes.string,
  researcher_job_title: PropTypes.string,
  methodologies_markup: PropTypes.string,
  recording_markup: PropTypes.string,
  finalPreview: PropTypes.bool
}

export default WhatHappensInThisResearchSession
