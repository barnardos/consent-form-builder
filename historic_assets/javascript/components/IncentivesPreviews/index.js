import React from "react";
import PreviewBase from "../Shared/PreviewBase";
import Incentives from "../Shared/Incentives";

class IncentivesPreviews extends PreviewBase {
  componentName() {
    return "IncentivesPreviews";
  }

  render() {
    return (
      <section className="reactive-preview__section">
        <h3 className="reactive-preview__heading" id="session">
          Session details
        </h3>
        <p>&hellip;</p>
        <Incentives {...this.state} />
        <p>&hellip;</p>
      </section>
    );
  }
}

export default IncentivesPreviews;
