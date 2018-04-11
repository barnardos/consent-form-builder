import React from "react";
import PropTypes from "prop-types";
import PreviewBase from "../Shared/PreviewBase";
import Output from "../Shared/Output";

class TopicPurposePreviews extends PreviewBase {
  componentName() {
    return "TopicPurposePreviews";
  }

  render() {
    return (
      <div>
        <h3
          className={this.props.finalPreview ? "" : "reactive-preview__heading"}
          id="why"
        >
          Why we are doing research
        </h3>
        <p>
          {this.props.labels.topic} {Output(this.state, "topic")}{" "}
          {this.props.labels.purpose} {Output(this.state, "purpose")}
          {"."}
        </p>
      </div>
    );
  }
}

TopicPurposePreviews.propTypes = {
  topic: PropTypes.string,
  purpose: PropTypes.string,
  labels: PropTypes.object,
  finalPreview: PropTypes.bool
};

TopicPurposePreviews.defaultProps = {
  finalPreview: false
};

export default TopicPurposePreviews;
