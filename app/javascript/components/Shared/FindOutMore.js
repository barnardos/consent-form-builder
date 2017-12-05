import React from 'react'
import PropTypes from 'prop-types'
import Output from './Output'

const FindOutMore = (props) => {
  let researcherPhone = ''

  if (props['researcher_phone'] && props['researcher_phone'].length > 0) {
    researcherPhone = <div>
      <dt>Telephone:</dt>
      <dd>{Output(props, 'researcher_phone')}</dd>
    </div>
  }

  return (
    <section className={ props.finalPreview ? '' : 'reactive-preview__section' }>
      <h3 className="subtitle-small" id="more">Find out more</h3>
      <p>If you have any questions about the research please contact {Output(props, 'researcher_name')}:</p>
      <dl className="definition-list">
        <div>
          <dt>Email:</dt>
          <dd>{Output(props, 'researcher_email')}</dd>
        </div>
        {researcherPhone}
      </dl>
    </section>
  )
}

FindOutMore.propTypes = {
  researcher_phone: PropTypes.string,
  researcher_email: PropTypes.string,
  finalPreview: PropTypes.bool
}
export default FindOutMore
