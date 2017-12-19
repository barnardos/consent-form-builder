import React from 'react'
import DisplayAdditionalCopy from './DisplayAdditionalCopy'

describe('DisplayAdditionalCopy', () => {
  describe('When on final preview', () => {
    it('displays the content', () => {
      const content = 'Display this content'
      const mountedComponent = mount(
        <DisplayAdditionalCopy
          content={content}
          finalPreview={true} />
      )

      expect(mountedComponent).to.contain(content)
    })
  })

  describe('When on step', () => {
    it('shows placeholder', () => {
      const content = 'Do not display this'
      const mountedComponent = mount(
        <DisplayAdditionalCopy
          content={content}
          finalPreview={false} />
      )

      expect(mountedComponent).to.contain(<span>&hellip;</span>)
    })
  })
})
