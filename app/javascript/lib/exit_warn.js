/* eslint import/unambiguous:0 */
let changed = false
const form = document.querySelector('form')

function beforeUnload (event) {
  const message = 'You have unsaved changes'

  event = event || window.event
  // For IE and Firefox
  if (event) {
    event.returnValue = message
  }

  // For Safari
  return message
}

if (form) {
  form.addEventListener('submit', () => {
    window.removeEventListener('beforeunload', beforeUnload)
  })

  form.addEventListener('change', () => {
    if (!changed) {
      changed = true
      window.addEventListener('beforeunload', beforeUnload)
    }
  })
}
