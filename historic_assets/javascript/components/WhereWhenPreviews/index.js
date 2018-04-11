import React from "react";
import PreviewBase from "../Shared/PreviewBase";
import SessionInformation from "../Shared/SessionInformation";
import ParticipantEquipment from "../Shared/ParticipantEquipment";
import Refreshments from "../Shared/Refreshments";

class WhereWhenPreviews extends PreviewBase {
  componentName() {
    return "WhereWhenPreviews";
  }

  render() {
    return (
      <section className="reactive-preview__section">
        <h3 className="reactive-preview__heading" id="session">
          Session details
        </h3>
        <SessionInformation {...this.state} />
        <span>&hellip;</span>
        <ParticipantEquipment {...this.state} />
        <span>&hellip;</span>
        <Refreshments {...this.state} />
      </section>
    );
  }
}

export default WhereWhenPreviews;
