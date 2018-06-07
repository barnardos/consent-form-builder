import "./index.css";
import FormatCurrency from "../../utils/FormatCurrency";

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
    const { node } = this;
    let value = target.value;

    if (node.getAttribute("data-format-value") === "currency" && value) {
      value = FormatCurrency(value);
    }

    node.innerText = value;
  }
}

document.querySelectorAll("[data-listens-to]").forEach(node => {
  new FieldPreview(node);
});
