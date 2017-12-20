/* eslint import/unambiguous:0 */
global.requestAnimationFrame = (callback) => {
  setTimeout(callback, 0)
}
