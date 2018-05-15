import "./index.css";

class FieldPreview {
  constructor(node) {
    this.node = node;
    this.handleChangeEvent = this.handleChangeEvent.bind(this);
    this.addListener = this.addListener.bind(this);

    this.addListener();
  }

  addListener() {
    document
      .querySelector(this.node.getAttribute("data-listens-to"))
      .addEventListener("keyup", this.handleChangeEvent);
  }

  handleChangeEvent({ target }) {
    this.node.innerText = target.value;
  }
}

document.querySelectorAll("[data-listens-to]").forEach(node => {
  new FieldPreview(node);
});
