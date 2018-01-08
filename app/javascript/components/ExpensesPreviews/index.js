import React from "react";
import PreviewBase from "../Shared/PreviewBase";
import SessionDetails from "../Shared/SessionDetails";

class ExpensesPreviews extends PreviewBase {
  componentName() {
    return "ExpensesPreviews";
  }

  render() {
    let expenses_enabled = this.state.expenses_enabled || false;
    if (JSON.parse(expenses_enabled)) {
      return <SessionDetails {...this.state} />;
    } else {
      return <div />;
    }
  }
}

export default ExpensesPreviews;
