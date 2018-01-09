import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";

const anotherResearcherSentence = props => {
  let anotherResearcherSentence;

  if (props.finalPreview) {
    anotherResearcherSentence = (
      <p>
        There may be another researcher or observer supporting{" "}
        {Output(props, "researcher_name")} at this session.
      </p>
    );
  } else {
    anotherResearcherSentence = <p>&hellip;</p>;
  }
  return anotherResearcherSentence;
};

anotherResearcherSentence.propTypes = {
  researcher_name: PropTypes.string,
  finalPreview: PropTypes.bool
};

export default anotherResearcherSentence;
