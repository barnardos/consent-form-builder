const { addClass, removeClass } = require('../lib/element_helpers')

const WRAPPER_DATA = 'data-hide-control'
const HIDDEN_CLASS = 'visually-hidden'

class HideThisOtherThing {
  constructor (checkbox, otherThing) {
    this.checkbox = checkbox
    this.otherThing = otherThing
    this.attachEvents()
  }

  attachEvents () {
    this.checkbox.addEventListener('change', this.updateOther.bind(this))
  }

  updateOther () {
    if (this.checkbox.checked) {
      removeClass(this.otherThing, HIDDEN_CLASS)
    } else {
      addClass(this.otherThing, HIDDEN_CLASS)
    }
  }

  static init (container = document) {
    Array
      .from(container.querySelectorAll(`[${WRAPPER_DATA}]`))
      .forEach((element) => {
        let elementToHide =
          document.getElementById(element.dataset.hideControl).parentElement
        let hider = new HideThisOtherThing(element, elementToHide)
        hider.updateOther()
      })
  }
}

module.exports = HideThisOtherThing
