import React from "react";
import PropTypes from "prop-types";
import PreviewBase from "../Shared/PreviewBase";
import WillAnyoneKnowWhatISayInTheDiscussion from "../Shared/WillAnyoneKnowWhatISayInTheDiscussion";

class StoringPreviews extends PreviewBase {
  componentName() {
    return "StoringPreviews";
  }

  render() {
    return (
      <div>
        <WillAnyoneKnowWhatISayInTheDiscussion {...this.state} />
      </div>
    );
  }
}

StoringPreviews.propTypes = {
  shared_duration: PropTypes.string,
  shared_with_sentences: PropTypes.object,
  shared_with: PropTypes.string,
  able_to_consent: PropTypes.bool,
  shared_title: PropTypes.string,
  finalPreview: PropTypes.bool
};

export default StoringPreviews;
