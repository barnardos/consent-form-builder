/* eslint no-new: 0 */
const { addClass, removeClass } = require('../lib/element_helpers')

class PrintSection {
  constructor (form, container) {
    this.cacheElements(form, container)
    this.attachEvents()
  }

  cacheElements (form, container) {
    this.container = container
    this.form = form
    this.areaToPrintSelector = this.form.querySelector('.js-area-to-print')
    this.printAreas = this.container.querySelectorAll('.js-print-area')
  }

  print (e) {
    e.preventDefault()
    addClass(this.printAreas, 'screen-only')
    removeClass(this.container.querySelectorAll(this.areaToPrintSelector.value), 'screen-only')
    window.print()
  }

  attachEvents () {
    this.form.addEventListener('submit', this.print.bind(this))
  }

  static init (container = document) {
    Array
      .from(container.querySelectorAll('.js-print-section'))
      .forEach((element) => {
        new PrintSection(element, container)
      })
  }
}

module.exports = PrintSection
