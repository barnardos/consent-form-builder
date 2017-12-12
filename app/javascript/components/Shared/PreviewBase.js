import React from 'react'

/*
 * Responsible for wiring itself up via the data-previewed-by attribute
 * such that it can reflect changes from oninput in those areas via
 * handleInputChange, which is Rails field naming convention-aware
 */
class PreviewBase extends React.Component {
  // Abstract

  constructor (props) {
    super(props)
    this.state = props
  }

  componentName() {
    throw new Error('componentName should be implemented in base classes')
  }

  componentDidMount () {
    Array.from(
      document.querySelectorAll(`[data-previewed-by=${this.constructor.name}]`)
    ).forEach(element => {
      element.oninput = this.handleInputChange.bind(this)
    })
  }

  handleInputChange (event) {
    const { target: { value, name: railsName } } = event

    const namePattern = /research_session\[(.*)\]/
    const name = namePattern.exec(railsName)[1]

    this.setState({
      [name]: value
    })
  }
}

export default PreviewBase
