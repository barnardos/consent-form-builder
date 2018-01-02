import React from "react";
import PropTypes from "prop-types";
import PreviewBase from "../Shared/PreviewBase";
import FindOutMore from "../Shared/FindOutMore";
import TakePartIn from "../Shared/TakePartIn";
import AnotherResearcherSentence from "../Shared/AnotherResearcherSentence";

class ResearcherPreviews extends PreviewBase {
  componentName() {
    return "ResearcherPreviews";
  }

  render() {
    return (
      <div>
        <section className="reactive-preview__section">
          <h3 className="reactive-preview__heading">
            What happens in this research session?
          </h3>
          <TakePartIn {...this.state} />
          <AnotherResearcherSentence {...this.state} />
        </section>
        <FindOutMore {...this.state} />
      </div>
    );
  }
}

ResearcherPreviews.propTypes = {
  researcher_job_title: PropTypes.string,
  researcher_name: PropTypes.string,
  researcher_email: PropTypes.string,
  researcher_phone: PropTypes.string
};

export default ResearcherPreviews;
