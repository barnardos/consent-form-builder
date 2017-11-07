import React, { Component } from 'react';
import './index.css';

import FieldGroup from '../FieldGroup';

class App extends Component {
  constructor (props) {
    super(props)
    this.state = {
      name: '',
      topic: '',
      purpose: '',
      recording: new Set()
    }

    this.handleInputChange = this.handleInputChange.bind(this)
  }

  handleInputChange (event) {
    const { target: { type, checked, value, name } } = event

    if (type === 'checkbox' && checked) {
      this.setState(prevState => ({
        [name]: new Set(prevState[name].add(value))
      }))
      return;
    }

    if (type === 'checkbox' && !checked) {
      this.setState(prevState => {
        prevState[name].delete(value)

        return {
          [name]: new Set(prevState[name])
        }
      })
      return;
    }

    this.setState({
      [name]: value
    })
  }

  render () {
    return (
      <div className="root">
        <div className="step">
          <form action="" className="form">
            <FieldGroup label="Researcher name" name="name">
              <input
                className="input"
                name="name"
                onChange={this.handleInputChange}
                type="text"
                value={this.state.name}
              />
            </FieldGroup>
          </form>
          <div className="previews">
            <p className="preview">
              <output className="output">{this.state.name}</output>
              <span> is the researcher who will be leading the session.</span>
            </p>
            <p className="preview">
              <output className="output">{this.state.name}</output> will be able
              to answer further questions about the research.
            </p>
          </div>
        </div>
        <div className="step">
          <form action="" className="form">
            <FieldGroup
              label="Barnardo's is doing research to learn about"
              name="topic"
            >
              <input
                className="input"
                name="topic"
                onChange={this.handleInputChange}
                type="text"
                value={this.state.topic}
              />
            </FieldGroup>
            <FieldGroup label="so that we can" name="purpose">
              <input
                className="input"
                name="purpose"
                onChange={this.handleInputChange}
                type="text"
                value={this.state.purpose}
              />
            </FieldGroup>
          </form>
          <div className="previews">
            <p className="preview">
              Barnardo's is doing research to learn about{' '}
              <output className="output">{this.state.topic}</output> so that we
              can <output className="output">{this.state.purpose}</output>.
            </p>
          </div>
        </div>
        <div className="step">
          <form action="" className="form">
            <fieldset className="fieldset">
              <legend className="label">
                How will you be recording information?
              </legend>
              <div className="checkboxes">
                <div className="checkbox">
                  <label htmlFor="audio" className="checkbox-label">
                    Audio
                  </label>
                  <input
                    className="checkbox-input"
                    id="audio"
                    name="recording"
                    onChange={this.handleInputChange}
                    type="checkbox"
                    value="audio"
                  />
                </div>
                <div className="checkbox">
                  <label htmlFor="video" className="checkbox-label">
                    Video
                  </label>
                  <input
                    className="checkbox-input"
                    id="video"
                    name="recording"
                    onChange={this.handleInputChange}
                    type="checkbox"
                    value="video"
                  />
                </div>
                <div className="checkbox">
                  <label htmlFor="photographs" className="checkbox-label">
                    Photographs
                  </label>
                  <input
                    className="checkbox-input"
                    id="photographs"
                    name="recording"
                    onChange={this.handleInputChange}
                    type="checkbox"
                    value="photographs"
                  />
                </div>
                <div className="checkbox">
                  <label htmlFor="screenRecordings" className="checkbox-label">
                    Screen Recordings
                  </label>
                  <input
                    className="checkbox-input"
                    id="screenRecordings"
                    name="recording"
                    onChange={this.handleInputChange}
                    type="checkbox"
                    value="screen recordings"
                  />
                </div>
              </div>
            </fieldset>
          </form>
          <div className="previews">
            <p className="preview">
              With your permission we will record your childʼs/the child in your
              care‘s session using{' '}
              <output className="output">
                {[...this.state.recording].join(', ')}
              </output>.
            </p>
          </div>
        </div>
      </div>
    )
  }
}

export default App
