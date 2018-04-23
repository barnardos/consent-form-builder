import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";

const SessionInformation = props => {
  const { when_text, location, duration, finalPreview } = props;

  let sessionTime = <span />;
  if (when_text || !finalPreview) {
    sessionTime = <p>When: {Output(props, "when_text")}</p>;
  }

  let sessionLocation = <span />;
  if (location || !finalPreview) {
    sessionLocation = <p>Where: {Output(props, "location")}</p>;
  }

  let sessionDuration = <span />;
  if (duration || !finalPreview) {
    sessionDuration = <p>Duration: {Output(props, "duration")}</p>;
  }

  return (
    <div>
      {sessionTime}
      {sessionLocation}
      {sessionDuration}
    </div>
  );
};

SessionInformation.propTypes = {
  when_text: PropTypes.string,
  duration: PropTypes.string,
  location: PropTypes.string,
  finalPreview: PropTypes.bool
};

export default SessionInformation;
