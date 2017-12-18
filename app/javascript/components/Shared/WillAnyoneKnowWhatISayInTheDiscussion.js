import React from 'react'
import PropTypes from 'prop-types'
import Output from './Output'

const WillAnyoneKnowWhatISayInTheDiscussion = (props) => {
  return (
    <div className="reactive-container__preview">
      <section className='reactive-preview__section'>
        <h3 className="reactive-preview__heading" id="storing">Will anyone know what they say in the discussion?</h3>
        <p>
          The only people who will hear what you say in the session will be the researchers
          running the session, other young people taking part, and service workers
          facilitating the session.
        </p>
        <p>
          {Output(props, 'shared_with')}
        </p>
        <p>
          Barnardo’s will hold research data for{' '}
          {Output(props, 'shared_duration')}{' '}
          after the closure of this project, after which it will
          be deleted. Personal data is stored in a safe and secure way.
        </p>
        <p>
          You can contact Jason Caplin to ask us to delete your personal data at any time.
        </p>
      </section>
    </div>
  )
}

WillAnyoneKnowWhatISayInTheDiscussion.propTypes = {
  shared_duration: PropTypes.string,
  shared_with: PropTypes.string,
  finalPreview: PropTypes.bool
}

export default WillAnyoneKnowWhatISayInTheDiscussion
