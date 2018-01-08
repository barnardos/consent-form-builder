import React from "react";
import PreviewBase from "../Shared/PreviewBase";
import Expenses from "../Shared/Expenses";

class ExpensesPreviews extends PreviewBase {
  componentName() {
    return "ExpensesPreviews";
  }

  render() {
    return (
      <section className="reactive-preview__section">
        <h3 className="reactive-preview__heading" id="session">
          Session details
        </h3>
        <span>&hellip;</span>
        <Expenses {...this.state} />
        <span>&hellip;</span>
      </section>
    );
  }
}

export default ExpensesPreviews;
