import "./index.css";

class ChoicePreview {
  constructor(node) {
    this.node = node;
    this.handleChangeEvent = this.handleChangeEvent.bind(this);
    this.addListener = this.addListener.bind(this);

    this.addListener();
  }

  addListener() {
    document
      .querySelector(this.node.getAttribute("data-controlled-by"))
      .addEventListener("change", this.handleChangeEvent);
  }

  handleChangeEvent() {
    this.node.classList.toggle("ChoicePreview--isActive");
  }
}

document.querySelectorAll("[data-choice-preview]").forEach(node => {
  new ChoicePreview(node);
});
