import React from "react";
import PropTypes from "prop-types";
import PreviewBase from "../Shared/PreviewBase";
import TakePartIn from "../Shared/TakePartIn";
import WeWillRecordBy from "../Shared/WeWillRecordBy";
import AnotherResearcherSentence from "../Shared/AnotherResearcherSentence";

class MethodologyPreviews extends PreviewBase {
  componentName() {
    return "MethodologyPreviews";
  }

  render() {
    return (
      <section className="reactive-preview__section">
        <h3 className="reactive-preview__heading">
          What happens in this research session?
        </h3>
        <TakePartIn {...this.state} />
        <WeWillRecordBy {...this.state} />
        <AnotherResearcherSentence {...this.state} />
      </section>
    );
  }
}

MethodologyPreviews.propTypes = {
  all_methodologies: PropTypes.object,
  other_methodology: PropTypes.string,
  methodologies: PropTypes.array
};

export default MethodologyPreviews;
