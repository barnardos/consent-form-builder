import "./index.css";

class OptionalField {
  constructor(node) {
    this.node = node;
    this.handleChangeEvent = this.handleChangeEvent.bind(this);
    this.addControllerListener = this.addControllerListener.bind(this);

    this.addControllerListener();
  }

  addControllerListener() {
    document
      .querySelector(this.node.getAttribute("data-controlled-by"))
      .addEventListener("change", this.handleChangeEvent);
  }

  handleChangeEvent() {
    this.node.classList.toggle("OptionalField--active");
  }
}

document.querySelectorAll("[data-optional-field]").forEach(node => {
  new OptionalField(node);
});
