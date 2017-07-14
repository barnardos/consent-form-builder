const elementHelpers = require('../../../app/javascript/lib/element_helpers')

const markup = `
  <html>
    <body>
      <div id="test-element-a" class="test">Test</div>
      <div id="test-element-b" class="">Test</div>
      <div id="test-element-c" class="cat dog">Test</div>
    </body>
  </html>
`

function domTokenToArray (obj) {
  let array = []
  // iterate backwards ensuring that length is an UInt32
  for (let i = obj.length >>> 0; i--;) {
    array[i] = obj[i]
  }
  return array
}

describe('Element helpers', () => {
  beforeEach(() => {
    const document = render(markup)
    this.testElementA = document.getElementById('test-element-a')
    this.testElementB = document.getElementById('test-element-b')
    this.testElementC = document.getElementById('test-element-c')
  })

  describe('#addClass', () => {
    it('should add a class to an element with no classes', () => {
      elementHelpers.addClass(this.testElementB, 'test')
      expect(domTokenToArray(this.testElementB.classList)).to.include('test')
    })

    it('should add a class to an element with an existing class', () => {
      elementHelpers.addClass(this.testElementA, 'cat')
      expect(domTokenToArray(this.testElementA.classList)).to.include('test')
      expect(domTokenToArray(this.testElementA.classList)).to.include('cat')
    })

    it('should not add a class if the element already has it', () => {
      elementHelpers.addClass(this.testElementA, 'test')
      expect(this.testElementA.className).to.equal('test')
    })

    it('should not throw an error if you try to add a class to a null', () => {
      elementHelpers.addClass(this.null, 'test')
    })
  })

  describe('#removeClass', () => {
    it('should remove a class from an element that has it', () => {
      elementHelpers.removeClass(this.testElementC, 'cat')
      expect(domTokenToArray(this.testElementC.classList)).to.include('dog')
      expect(domTokenToArray(this.testElementC.classList)).to.not.include('cat')
    })
    it('should not throw an error if the class to remove is not there', () => {
      elementHelpers.removeClass(this.testElementC, 'shark')
    })
    it('should not throw an error if the element provided is null', () => {
      elementHelpers.removeClass(null, 'cat')
    })
  })

  describe('#hasClass', () => {
    it('returns true if a class is in an element', () => {
      expect(elementHelpers.hasClass(this.testElementA, 'test')).to.equal(true)
    })

    it('returns false if a class is not in an element', () => {
      expect(elementHelpers.hasClass(this.testElementB, 'test')).to.equal(false)
    })

    it('returns false if the element is null', () => {
      expect(elementHelpers.hasClass(null, 'test')).to.equal(false)
    })
  })
})
