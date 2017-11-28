import React from 'react'
import PropTypes from 'prop-types'
import Output from './Output'

const WhereCanIFindOutMore = (props) => {
  let researcherPhone = ''

  if (props['researcher_phone'] && props['researcher_phone'].length > 0) {
    researcherPhone = <span>or by telephone on {Output(props, 'researcher_phone')}</span>
  }

  return (
    <section className={ props.finalPreview ? '' : 'reactive-preview__section' }>
      <h3 className="subtitle-small" id="more">
        Where can I find out more?
      </h3>
      <p>
        {Output(props, 'researcher_name')} will be able to answer further questions about the
        research.{' '}
        {Output(props, 'researcher_name')} can be contacted by email at{' '}
        {Output(props, 'researcher_email')}{' '}
        {researcherPhone}
      </p>
    </section>
  )
}

WhereCanIFindOutMore.propTypes = {
  researcher_phone: PropTypes.string,
  finalPreview: PropTypes.bool
}
export default WhereCanIFindOutMore
