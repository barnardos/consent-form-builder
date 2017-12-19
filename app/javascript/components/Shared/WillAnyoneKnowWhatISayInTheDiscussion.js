import React from 'react'
import PropTypes from 'prop-types'
import Output from './Output'
import DisplayAdditionalCopy from './DisplayAdditionalCopy'

const WillAnyoneKnowWhatISayInTheDiscussion = (props) => {
  let sharedWithSentence = ''

  if (props.shared_with) {
    sharedWithSentence = props.shared_with_sentences[props.shared_with]
  }

  return (
    <div className="reactive-container__preview">
      <section className='reactive-preview__section'>
        <h3 className="reactive-preview__heading" id="storing">{props.shared_title}</h3>
        <p>
          <DisplayAdditionalCopy
            content="The only people who will hear what you say in the session will be the researchers running the session, other young people taking part, and service workers facilitating the session."
            finalPreview={props.finalPreview}
          />
        </p>
        <p>
          {Output(props, 'shared_with', sharedWithSentence)}
        </p>
        <p>
          Barnardo’s will hold research data for{' '}
          {Output(props, 'shared_duration')}{' '}
          after the closure of this project, after which it will
          be deleted. Personal data is stored in a safe and secure way.
        </p>
        <p>
          <DisplayAdditionalCopy
            content="You can contact Jason Caplin to ask us to delete your personal data at any time."
            finalPreview={props.finalPreview}
          />
        </p>
      </section>
    </div>
  )
}

WillAnyoneKnowWhatISayInTheDiscussion.propTypes = {
  shared_duration: PropTypes.string,
  shared_with: PropTypes.string,
  shared_with_sentences: PropTypes.object,
  shared_title: PropTypes.string,
  finalPreview: PropTypes.bool
}

export default WillAnyoneKnowWhatISayInTheDiscussion
