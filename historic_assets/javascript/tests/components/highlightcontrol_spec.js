/* eslint import/unambiguous:0 */
/* global render:true */
const HighlightControl = require("../../../app/javascript/components/highlightcontrol");
const { hasClass } = require("../../../app/javascript/lib/element_helpers");

const focusClass = "has-focus";
const markup = `
  <html>
    <body>
      <div class="textfield js-highlight-control" id="1">
        <label class='textfield__label' for="name">Name</label>
        <div id="name-hint" class='textfield__help'>Enter a full name here</div>
        <input
          type='text'
          class='textfield__input js-highlight-control__input'
          id="name"
          name="name"
          value="Fred smith"
          autoComplete="no"
        />
        <div id="name-error" class='textfield__error'>Here is an error</div>
      </div>
    </body>
  </html>
`;

describe("Highlight control", () => {
  beforeEach(() => {
    const document = render(markup);
    this.inputWrapper = document.querySelector(".js-highlight-control");
    this.inputControl = document.querySelector(".js-highlight-control__input");
    new HighlightControl(this.inputWrapper);
  });

  it("should initially show a field as not focused", () => {
    expect(hasClass(this.inputWrapper, focusClass)).to.be.equal(false);
  });

  it("should set the textfield area to indicate it is focused when the user focuses on the field", () => {
    this.inputControl.focus();
    expect(hasClass(this.inputWrapper, focusClass)).to.be.equal(true);
  });

  it("should remove the focus state when a user moves off a field", () => {
    this.inputControl.focus();
    this.inputControl.blur();
    expect(hasClass(this.inputWrapper, focusClass)).to.be.equal(false);
  });
});
