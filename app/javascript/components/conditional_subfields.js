/**
 * Conditional sub fields
 *
 * Supports the ability to conditionally show and hide content based on the
 * value of a field.
 *
 * The element to be shown requires 2 attributes:
 * [data-controlled-by] - this is the name of the field which controls it
 * [data-control-value] - the value by which this element should be displayed
 *
 * It also requires a basic bit of style to work:
 *
 * [data-controlled-by] {
 *   display: none;
 * }
 * [data-controlled-by].is-active {
 *   display: block;
 * }
 *
 * @example
 *
 * <label>
 *   <input name="control-field" value="yes" type="radio">Yes
 * </label>
 * <label>
 *   <input name="control-field" value="no" type="radio">No
 * </label>
 *
 * <div class="js-ConditionalSubfield" data-controlled-by="control-field" data-control-value="yes">
 *   Visible when `control-field` equals `yes`
 * </div>
 *
 */

const uniq = require('lodash/uniq')
const includes = require('lodash/includes')

const { addClass, removeClass } = require('../lib/element_helpers')

const ConditionalSubfields = {
  selector: 'js-ConditionalSubfield',
  activeClass: 'is-active',
  onChangeHandler: null,
  controllers: [],
  wrapper: null,

  init (wrapper = document) {
    this.wrapper = wrapper

    this.cacheEls()

    if (this.controllers.length) {
      this.bindEvents()
      this.render()
    }
  },

  cacheEls () {
    const conditionalSubFields = this.wrapper.getElementsByClassName(this.selector)

    this.onChangeHandler = this.onChange.bind(this)
    this.controllers = uniq([...conditionalSubFields].map((controller, i) => {
      return controller.getAttribute('data-controlled-by')
    }))
  },

  bindEvents () {
    this.wrapper.addEventListener('change', this.onChangeHandler)
  },

  render () {
    this.controllers.forEach((controller) => {
      const field = this.wrapper.querySelector(`[name="${controller}"]`)

      this._handleField(field)
    })
  },

  destroy () {
    this.wrapper.removeEventListener('change', this.onChangeHandler)
  },

  onChange (evt) {
    const field = evt.target
    if (includes(this.controllers, field.name)) {
      this._handleField(field)
    }
  },

  /**
   *
   * @param {Object} controlInput
   *
   * handles when a field value changes.
   * Get the value that changed and decide if we should show
   * or hide the optional subfield.
   *
   * If we hide the optional subfield, clear it's value also, so the form posts what the user expects
   */
  _handleField (controlInput) {
    if (!controlInput) {
      return
    }
    const subFields = this.wrapper.querySelectorAll(`[data-controlled-by="${controlInput.name}"]`)
    const tagName = controlInput.tagName
    let controlInputValue = []

    if (tagName === 'SELECT') {
      controlInputValue[0] = controlInput.value
    } else if (tagName === 'INPUT') {
      const type = controlInput.type

      if (type === 'radio' || type === 'checkbox') {
        controlInputValue = Array
          .from(this.wrapper.querySelectorAll(`[name="${controlInput.name}"]:checked`))
          .map(input => input.value)
      } else {
        controlInputValue[0] = controlInput.value
      }
    }

    Array.from(subFields).forEach((subField) => {
      const value = subField.getAttribute('data-control-value') + ''
      let isVisible

      isVisible = controlInputValue.includes(value)

      this._toggleSubField(subField, isVisible)
    })
  },

  _toggleSubField (subField, isVisible) {
    if (isVisible) {
      addClass(subField, this.activeClass)
    } else {
      removeClass(subField, this.activeClass)
    }

    subField.setAttribute('aria-expanded', isVisible)
    subField.setAttribute('aria-hidden', !isVisible)

    const children = subField.querySelectorAll('input, select, checkbox, textarea')

    Array.from(children).forEach((field) => {
      if (isVisible) {
        field.removeAttribute('disabled')
      } else {
        field.setAttribute('disabled', 'disabled')
      }
    })
  }
}

module.exports = ConditionalSubfields
