const ConditionalSubfields = require('../../../app/javascript/components/conditional_subfields')

describe.only('Conditional subfields', () => {
  describe('<select>', () => {
    it('should reveal an optional fragment if the initial value is the trigger value', () => {
      const markup = `
        <html>
          <body>
            <select id="select" name="colour">
              <option value="">Select an option</option>
              <option value="green">Green</option
              <option value="red">Red</option>
              <option id="other-option" value="other" selected>Other</option>
            </select>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="colour"
              data-control-value="other">
              <input name="other_colour">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should mark a fragment visible with target value selected', () => {
      const markup = `
        <html>
          <body>
            <select id="select" name="colour">
              <option value="">Select an option</option>
              <option value="green">Green</option
              <option value="red">Red</option>
              <option id="other-option" value="other">Other</option>
            </select>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="colour"
              data-control-value="other">
              <input name="other_colour">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      // Change the source field to the trigger value
      const select = document.getElementById('select')
      select.value = 'other'
      ConditionalSubfields.onChange({ target: select })

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should hide the optional field if the trigger is initially set then deselected', () => {
      const markup = `
        <html>
          <body>
            <select id="select" name="colour">
              <option value="">Select an option</option>
              <option value="green">Green</option
              <option value="red">Red</option>
              <option id="other-option" value="other" selected>Other</option>
            </select>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="colour"
              data-control-value="other">
              <input name="other_colour">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      const select = document.getElementById('select')
      select.value = 'green'
      ConditionalSubfields.onChange({ target: select })

      expect(document.getElementById('subfield-wrapper').className).to.not.include('is-active')
    })

    it('should hide the optional field if the trigger is selected then deselected', () => {
      const markup = `
        <html>
          <body>
            <select id="select" name="colour">
              <option value="">Select an option</option>
              <option value="green">Green</option
              <option value="red">Red</option>
              <option id="other-option" value="other">Other</option>
            </select>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="colour"
              data-control-value="other">
              <input name="other_colour">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      // Change the source field to the trigger value
      const select = document.getElementById('select')
      select.value = 'other'
      ConditionalSubfields.onChange({ target: select })

      select.value = 'green'
      ConditionalSubfields.onChange({ target: select })

      expect(document.getElementById('subfield-wrapper').className).to.not.include('is-active')
    })
  })

  describe('<input type="radio">', () => {
    it('should reveal an optional fragment if the initial value is the trigger value', () => {
      const markup = `
        <html>
          <body>
            <fieldset>
              <legend>Do you have a name?</legend>

              <label>
                <input name="ask" value="yes" type="radio" checked>Yes
              </label>
              <label>
                <input name="ask" value="no" type="radio">No
              </label>
            </fieldset>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">
              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should reveal that optional fragment on page load when a hidden field is present', () => {
      const markup = `
        <fieldset id="methodologies-wrapper" class="checkbox-group checkbox-group__vertical ">
            <legend class="checkbox-group__legend">How will you be gathering information?</legend>
            <input type="hidden" name="research_session[methodologies][]" value="">
            <div><input type="checkbox" value="interview"
                        checked="checked" name="research_session[methodologies][]"
                        id="research_session_methodologies_interview">
                <label for="research_session_methodologies_interview">Interview</label></div>
            <div><input type="checkbox" value="usability"
                        name="research_session[methodologies][]"
                        id="research_session_methodologies_usability">
                <label for="research_session_methodologies_usability">Usability testing</label></div>
            <div><input type="checkbox" value="other"
                        checked="checked" name="research_session[methodologies][]"
                        id="research_session_methodologies_other">
                <label for="research_session_methodologies_other">Other</label></div>
        </fieldset>      
        <div id="subfield-wrapper" class="js-ConditionalSubfield" data-controlled-by="research_session[methodologies][]"
             data-control-value="other">
            <div id="other_methodology-wrapper" class="textfield js-highlight-control ">
                <label class="textfield__label" for="research_session_other_methodology">
                    What is the other methodology?
                </label>
                <input class="textfield__input js-highlight-control__input " type="text"
                       value="Things" name="research_session[other_methodology]"
                       id="research_session_other_methodology"></div>
        </div>        
      `

      const document = render(markup)
      ConditionalSubfields.init(document)

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should mark a fragment visible with target value selected', () => {
      const markup = `
        <html>
          <body>
            <fieldset>
              <legend>Do you have a name?</legend>

              <label>
                <input id="ask-yes" name="ask" value="yes" type="radio">Yes
              </label>
              <label>
                <input name="ask" value="no" type="radio">No
              </label>
            </fieldset>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">
              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      // Change the source field to the trigger value
      const input = document.getElementById('ask-yes')
      input.checked = true
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should hide the optional field if the trigger is initially set then deselected', () => {
      const markup = `
        <html>
          <body>
            <fieldset>
              <legend>Do you have a name?</legend>

              <label>
                <input id="ask-yes" name="ask" value="yes" type="radio" checked>Yes
              </label>
              <label>
                <input id="ask-no" name="ask" value="no" type="radio">No
              </label>
            </fieldset>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">
              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      const input = document.getElementById('ask-yes')
      input.checked = false
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.not.include('is-active')
    })

    it('should hide the optional field if the trigger is selected then deselected', () => {
      const markup = `
        <html>
          <body>
            <fieldset>
              <legend>Do you have a name?</legend>

              <label>
                <input id="ask-yes" name="ask" value="yes" type="radio">Yes
              </label>
              <label>
                <input name="ask" value="no" type="radio">No
              </label>
            </fieldset>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">
              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      // Change the source field to the trigger value
      const input = document.getElementById('ask-yes')
      input.checked = true
      ConditionalSubfields.onChange({ target: input })

      input.checked = false
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.not.include('is-active')
    })
  })

  describe('<input type="checkbox">', () => {
    it('should reveal an optional fragment if the initial value is the trigger value', () => {
      const markup = `
        <html>
          <body>
            <fieldset>
              <legend>Do you have a name?</legend>

              <label>
                <input name="ask" value="yes" type="checkbox" checked>Yes
              </label>
              <label>
                <input name="ask" value="no" type="checkbox">No
              </label>
            </fieldset>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">
              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should mark a fragment visible with target value selected', () => {
      const markup = `
        <html>
          <body>
            <fieldset>
              <legend>Do you have a name?</legend>

              <label>
                <input id="ask-yes" name="ask" value="yes" type="checkbox">Yes
              </label>
              <label>
                <input name="ask" value="no" type="checkbox">No
              </label>
            </fieldset>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">
              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      // Change the source field to the trigger value
      const input = document.getElementById('ask-yes')
      input.checked = true
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should hide the optional field if the trigger is initially set then deselected', () => {
      const markup = `
        <html>
          <body>
            <fieldset>
              <legend>Do you have a name?</legend>

              <label>
                <input id="ask-yes" name="ask" value="yes" type="checkbox" checked>Yes
              </label>
              <label>
                <input id="ask-no" name="ask" value="no" type="checkbox">No
              </label>
            </fieldset>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">
              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      const input = document.getElementById('ask-yes')
      input.checked = false
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.not.include('is-active')
    })

    it('should hide the optional field if the trigger is selected then deselected', () => {
      const markup = `
        <html>
          <body>
            <fieldset>
              <legend>Do you have a name?</legend>

              <label>
                <input id="ask-yes" name="ask" value="yes" type="checkbox">Yes
              </label>
              <label>
                <input name="ask" value="no" type="checkbox">No
              </label>
            </fieldset>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">
              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      // Change the source field to the trigger value
      const input = document.getElementById('ask-yes')
      input.checked = true
      ConditionalSubfields.onChange({ target: input })

      input.checked = false
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.not.include('is-active')
    })
  })

  describe('<input type="text"> ', () => {
    it('should reveal an optional fragment if the initial value is the trigger value', () => {
      const markup = `
        <html>
          <body>
            <div>
              <label for="ask">Do you have a name:</label>
              <input id="ask" name="ask" value="yes" type="text" value="yes">
            </div>
            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">

              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should mark a fragment visible with target value selected', () => {
      const markup = `
        <html>
          <body>
            <div>
              <label for="ask">Do you have a name:</label>
              <input id="ask" name="ask" value="yes" type="text" value="no">
            </div>
            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">

              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      // Change the source field to the trigger value
      const input = document.getElementById('ask')
      input.value = 'yes'
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.include('is-active')
    })

    it('should hide the optional field if the trigger is initially set then deselected', () => {
      const markup = `
        <html>
          <body>
            <div>
              <label for="ask">Do you have a name:</label>
              <input id="ask" name="ask" value="yes" type="text" value="yes">
            </div>
            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">

              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      const input = document.getElementById('ask')
      input.value = 'no'
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.not.include('is-active')
    })

    it('should hide the optional field if the trigger is selected then deselected', () => {
      const markup = `
        <html>
          <body>
            <div>
              <label for="ask">Do you have a name:</label>
              <input id="ask" name="ask" value="yes" type="text" value="yes">
            </div>
            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="ask"
              data-control-value="yes">

              <input name="name">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      // Change the source field to the trigger value
      const input = document.getElementById('ask')
      input.value = 'yes'
      ConditionalSubfields.onChange({ target: input })

      input.value = 'no'
      ConditionalSubfields.onChange({ target: input })

      expect(document.getElementById('subfield-wrapper').className).to.not.include('is-active')
    })
  })

  describe('clear optional field values', () => {
    it('should clear a single optional field when it is hidden', () => {
      const markup = `
        <html>
          <body>
            <select id="select" name="colour">
              <option value="">Select an option</option>
              <option value="green">Green</option
              <option value="red">Red</option>
              <option id="other-option" value="other" selected>Other</option>
            </select>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="colour"
              data-control-value="other">

              <input name="other_colour" value="something">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      const select = document.getElementById('select')
      select.value = 'green'
      ConditionalSubfields.onChange({ target: select })

      expect(document.querySelector('[name="other_colour"][disabled]').value).to.equal('something')
    })

    it('should clear multiple optional fields when they are hidden', () => {
      const markup = `
        <html>
          <body>
            <select id="select" name="colour">
              <option value="">Select an option</option>
              <option value="green">Green</option
              <option value="red">Red</option>
              <option id="other-option" value="other" selected>Other</option>
            </select>

            <div
              id="subfield-wrapper"
              class="js-ConditionalSubfield"
              data-controlled-by="colour"
              data-control-value="other">

              <input name="other_colour" value="something">
              <input name="other_shade" value="dark">
            </div>
          </body>
        </html>`

      const document = render(markup)
      ConditionalSubfields.init(document)

      const select = document.getElementById('select')
      select.value = 'green'
      ConditionalSubfields.onChange({ target: select })

      expect(document.querySelector('[name="other_colour"][disabled]').value).to.equal('something')
      expect(document.querySelector('[name="other_shade"][disabled]').value).to.equal('dark')
    })
  })
})
