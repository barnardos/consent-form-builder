import "./index.css";

class PrintAreaCommand {
  constructor(node) {
    this.node = node;
    this.areaToPrint = node.getAttribute("data-area-to-print");
    this.printableAreas = document.querySelectorAll("[data-print-area]");
    this.printArea = this.printArea.bind(this);
    this.addListener = this.addListener.bind(this);

    this.addListener();
  }

  addListener() {
    this.node.addEventListener("click", this.printArea);
  }

  printArea(event) {
    const { areaToPrint, printableAreas } = this;

    event.preventDefault();

    if (areaToPrint) {
      printableAreas.forEach(node =>
        node.classList.add("PrintArea--screenOnly")
      );

      document
        .querySelector(`[data-print-area="${areaToPrint}"]`)
        .classList.remove("PrintArea--screenOnly");
    } else {
      printableAreas.forEach(node =>
        node.classList.remove("PrintArea--screenOnly")
      );
    }

    window.print();
  }
}

document.querySelectorAll("[data-print-area-command]").forEach(node => {
  new PrintAreaCommand(node);
});
