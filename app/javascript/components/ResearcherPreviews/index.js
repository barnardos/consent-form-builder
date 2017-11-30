import React from 'react'
import PropTypes from 'prop-types'
import WhoIsDoingTheResearch from './WhoIsDoingTheResearch'
import WhereCanIFindOutMore from '../Shared/WhereCanIFindOutMore'

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

  render () {
    return (
      <div>
        <WhoIsDoingTheResearch {...this.state} />
        <WhereCanIFindOutMore {...this.state} />
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
