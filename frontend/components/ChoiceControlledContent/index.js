import "./index.css";

class ChoiceControlledContent {
  constructor(node) {
    this.node = node;
    this.controlledByNode = document.querySelector(
      this.node.getAttribute("data-controlled-by")
    );
    this.handleChangeEvent = this.handleChangeEvent.bind(this);
    this.addControllerListener = this.addControllerListener.bind(this);

    this.addControllerListener();
  }

  addControllerListener() {
    this.controlledByNode
      .closest("[data-of-many-choice-control]")
      .addEventListener("change", this.handleChangeEvent);
  }

  handleChangeEvent({ target }) {
    const { controlledByNode, node } = this;

    if (target !== controlledByNode && target.type !== "radio") {
      return false;
    }

    if (controlledByNode.checked) {
      node.classList.add("ChoiceControlledContent--active");
    } else {
      node.classList.remove("ChoiceControlledContent--active");
    }
  }
}

document.querySelectorAll("[data-choice-controlled-content]").forEach(node => {
  new ChoiceControlledContent(node);
});
