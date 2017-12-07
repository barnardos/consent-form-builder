import React from 'react'
import PropTypes from 'prop-types'
import Output from '../Shared/Output'

class TopicPurposePreviews extends React.Component {
  constructor (props) {
    super(props)

    if (!props.finalPreview) {
      Array.from(
        document.querySelectorAll('[data-previewed-by=TopicPurposePreviews]')
      ).forEach(element => {
        element.oninput = this.handleInputChange.bind(this)
      })
    }

    this.state = props
  }

  handleInputChange (event) {
    const { target: { value, name: railsName } } = event

    const namePattern = /research_session\[(.*)\]/
    const name = namePattern.exec(railsName)[1]

    this.setState({
      [name]: value
    })
  }

  render () {
    return (
      <div>
        <h3 className="subtitle-small" id="why">Why we are doing research</h3>

        <p>
          {this.props.labels.topic}
          {' '}{Output(this.state, 'topic')}{' '}
          {this.props.labels.purpose}
          {' '}{Output(this.state, 'purpose')}{'.'}
        </p>
      </div>
    )
  }
}

TopicPurposePreviews.propTypes = {
  topic: PropTypes.string,
  purpose: PropTypes.string,
  labels: PropTypes.object,
  finalPreview: PropTypes.bool
}

TopicPurposePreviews.defaultProps = {
  finalPreview: false
}

export default TopicPurposePreviews
