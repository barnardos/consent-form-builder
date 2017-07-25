/* eslint no-new: 0 */
const { addClass, removeClass } = require('../lib/element_helpers')

const focusClass = 'has-focus'
const wrapperClass = 'js-highlight-control'

class HighlightControl {
  constructor (wrapperElement) {
    this.cacheElements(wrapperElement)
    this.attachEvents()
  }

  cacheElements (wrapperElement) {
    this.wrapperElement = wrapperElement
    this.input = wrapperElement.querySelector('.js-highlight-control__input')
  }

  showFocus () {
    addClass(this.wrapperElement, focusClass)
  }

  removeFocus () {
    removeClass(this.wrapperElement, focusClass)
  }

  attachEvents () {
    this.input.addEventListener('focus', this.showFocus.bind(this))
    this.input.addEventListener('blur', this.removeFocus.bind(this))
  }

  static init (container = document) {
    container.querySelectorAll(`.${wrapperClass}`).forEach((element) => {
      new HighlightControl(element)
    })
  }
}

module.exports = HighlightControl
