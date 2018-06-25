import "./index.css";

class PrintCommand {
  constructor(node) {
    this.node = node;
    this.print = this.print.bind(this);
    this.addListener = this.addListener.bind(this);

    this.addListener();
  }

  addListener() {
    this.node.addEventListener("click", this.print);
  }

  print(event) {
    event.preventDefault();
    window.print();
  }
}

document.querySelectorAll("[data-print-command]").forEach(node => {
  new PrintCommand(node);
});
