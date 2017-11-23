import React from 'react'
import PropTypes from 'prop-types'

class ResearcherPreviews extends React.Component {
  constructor (props) {
    super(props)

    Array.from(
      document.querySelectorAll('[data-previewed-by=ResearcherPreviews]')
    ).forEach(element => {
      element.oninput = this.handleInputChange.bind(this)
    })

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

  editLinkFor (attr) {
    const attrValue = this.state[attr]
    if(this.state.finalPreview) {
      return(
        <output className="highlight">
          <a className="editable" href={this.state.editLinks[attr]}>
            {attrValue}
          </a>
        </output>
      )
    }

    return(
      <output className="highlight">
        {attrValue}
      </output>
    )
  }

  render () {
    const present = (attr) => { return this.state[attr] && this.state[attr].length > 0 }

    let otherResearcher, researcherPhone
    if (present('researcher_other_name')) {
      otherResearcher = (
        <span>
          <output className="highlight">{this.state.researcher_name}'s</output>{' '}
          colleague,{' '}
          <output className="highlight">
            {this.state.researcher_other_name}
          </output>{' '}
          may join sometimes to help.
        </span>
      )
    } else {
      otherResearcher = ''
    }

    if (present('researcher_phone')) {
      researcherPhone = <span>or by telephone on {this.editLinkFor('researcher_phone')}</span>
    } else {
      researcherPhone = ''
    }

    return (
      <div className="previews">
        <section className="preview">
          <h3 className="subtitle-small" id="who">
            Who is doing the research?
          </h3>
          <p>
            {this.editLinkFor('researcher_name')}{', '}
            {this.editLinkFor('researcher_job_title')}{', '}
            is the researcher who will be leading the session.&nbsp;
            {otherResearcher}
          </p>
        </section>
        <section className="preview">
          <h3 className="subtitle-small" id="more">
            Where can I find out more?
          </h3>
          <p>
            {this.editLinkFor('researcher_name')} will be able to answer further questions about the
            research.
            {this.editLinkFor('researcher_name')} can be contacted by email at{' '}
            {this.editLinkFor('researcher_email')}{' '}
            {researcherPhone}
          </p>
        </section>
      </div>
    )
  }
}

ResearcherPreviews.propTypes = {
  researcher_job_title: PropTypes.string,
  researcher_name: PropTypes.string,
  researcher_email: PropTypes.string,
  researcher_other_name: PropTypes.string,
  researcher_phone: PropTypes.string
}

export default ResearcherPreviews
