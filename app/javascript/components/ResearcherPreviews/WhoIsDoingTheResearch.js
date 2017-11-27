import React from 'react'
import PropTypes from 'prop-types'
import Output from './Output'

const WhoIsDoingTheResearch = props => {
  let jobTitle = ' '

  if (props.researcher_job_title) {
    jobTitle = <span>{', '}{Output(props, 'researcher_job_title')}{', '}</span>
  }

  return (
    <section className={ props.finalPreview ? '' : 'preview' }>
      <h3 className="subtitle-small" id="who">
        Who is doing the research?
      </h3>
      <p>
        {Output(props, 'researcher_name')}
        {jobTitle}
        is the researcher who will be leading the session.&nbsp;
        {otherResearcher(props)}
      </p>
    </section>
  )
}

const otherResearcher = (props) => {
  if (props.researcher_other_name) {
    return (
      <span>
        {Output(props, 'researcher_name')}&apos;s colleague,{' '}
        {Output(props, 'researcher_other_name')}{' '}
        may join sometimes to help.
      </span>
    )
  } else {
    return ''
  }
}

WhoIsDoingTheResearch.propTypes = {
  researcher_job_title: PropTypes.string,
  researcher_other_name: PropTypes.string,
  finalPreview: PropTypes.bool
}

otherResearcher.propTypes = {
  researcher_other_name: PropTypes.string
}
export default WhoIsDoingTheResearch
