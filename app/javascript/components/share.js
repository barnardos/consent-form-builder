/* eslint import/unambiguous:0 */
const Clipboard = require("clipboard");

class Share {
  constructor(container) {
    this.cacheElements(container);
    this.attachEvents();
  }

  cacheElements(container) {
    this.container = container;
    this.shareTriggers = this.container.querySelectorAll(".js-share-trigger");
    this.shareTargets = this.container.querySelectorAll(".js-share-target");
  }

  toggleTarget() {
    Array.from(this.shareTargets).forEach(element =>
      element.classList.toggle("is-active")
    );
  }

  attachEvents() {
    Array.from(this.shareTriggers).forEach(element =>
      element.addEventListener("click", this.toggleTarget.bind(this))
    );
  }

  static init(container = document) {
    new Share(container);
    new Clipboard(".js-copy-url-button");
  }
}

module.exports = Share;
