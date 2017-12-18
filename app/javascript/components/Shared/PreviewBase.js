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

  componentName () {
    throw new Error(
      'componentName should be implemented in derived classes ' +
      '(have you returned the name of the class?)'
    )
  }

  componentDidMount () {
    Array.from(
      document.querySelectorAll(`[data-previewed-by=${this.componentName()}]`)
    ).forEach(element => {
      if (element.type === 'checkbox') {
        element.onchange = this.handleCheckboxChange.bind(this)
      } else {
        element.oninput = this.handleTextOrRadioChange.bind(this)
      }
    })
  }

  handleTextOrRadioChange (event) {
    const { target: { value, name: railsName } } = event

    const namePattern = /research_session\[(.+?)]/
    const name = namePattern.exec(railsName)[1]

    this.setState({
      [name]: value
    })
  }

  handleCheckboxChange (event) {
    const { target: { checked, value, name: railsName } } = event

    const namePattern = /research_session\[(.+?)[[\]]/
    const name = namePattern.exec(railsName)[1]

    const values = new Set(this.state[name])

    if (checked) {
      values.add(value)
    } else {
      values.delete(value)
    }

    this.setState({
      [name]: Array.from(values)
    })
  }
}

export default PreviewBase
