import React from "react";
import PreviewBase from "../Shared/PreviewBase";
import SessionDetails from "../Shared/SessionDetails";

class WhereWhenPreviews extends PreviewBase {
  componentName() {
    return "WhereWhenPreviews";
  }

  render() {
    let where_when_enabled = this.state.where_when_enabled || false;
    if (JSON.parse(where_when_enabled)) {
      return <SessionDetails {...this.state} />;
    } else {
      return <div />;
    }
  }
}

export default WhereWhenPreviews;
