import React from 'react'
import Output from './Output'

describe('Output', () => {
  let props

  describe('A property is given', () => {
    beforeEach(() => {
      props = {
        my_property: 'this is my value',
        editLinks: {
          my_property: '/path/to/my_property'
        }
      }
    })

    describe('the preview is live', () => {
      beforeEach(() => {
        props['finalPreview'] = false
      })
      it('renders that property as an output', () => {
        const output = mount(Output(props, 'my_property'))
        expect(output).to.contain(
          <output className="reactive-preview__highlight">
            this is my value
          </output>
        )
      })
    })

    describe('the preview is final', () => {
      beforeEach(() => {
        props['finalPreview'] = true
      })
      it('renders that property as an output with a link to the path in editLinks', () => {
        const output = mount(Output(props, 'my_property'))
        expect(output).to.contain(
          <output className="reactive-preview__highlight">
            <a className="editable" href="/path/to/my_property">this is my value</a>
          </output>
        )
      })
      describe('a value override is given', () => {
        it('renders the override but keeps the link', () => {
          const output = mount(Output(props, 'my_property', 'the override'))
          expect(output).to.contain(
            <output className="reactive-preview__highlight">
              <a className="editable" href="/path/to/my_property">the override</a>
            </output>
          )
        })
      })
    })
  })
})
