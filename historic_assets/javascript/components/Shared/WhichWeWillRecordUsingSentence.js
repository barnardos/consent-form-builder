import React from "react";
import PropTypes from "prop-types";
import humanizeList from "humanize-list";
import sortAgainst from "./sort-against";
import Output from "./Output";

const WhichWeWillRecordUsingSentence = props => {
  let recordingMethodsSentence = "";

  if (props.recording_methods) {
    const sortedRecordingMethods = sortAgainst(
      props.recording_methods,
      props.all_recording_methods
    );
    const recordingMethodLabels = sortedRecordingMethods.map(method => {
      return method === "other"
        ? props.other_recording_method
        : props.all_recording_methods[method];
    });
    recordingMethodsSentence = humanizeList(recordingMethodLabels, {
      oxfordComma: true
    });
  }

  const childsIfUnable = props.able_to_consent ? "" : " childʼs";

  return (
    <li>
      I understand that my{childsIfUnable} activities during the research
      session may be observed and will be recorded. The data captured, in the
      form of {Output(props, "recording_methods", recordingMethodsSentence)}{" "}
      will be used for current and future service development.
    </li>
  );
};

WhichWeWillRecordUsingSentence.propTypes = {
  recording_methods: PropTypes.array,
  all_recording_methods: PropTypes.object,
  other_recording_method: PropTypes.string,
  able_to_consent: PropTypes.bool,
  finalPreview: PropTypes.bool
};

export default WhichWeWillRecordUsingSentence;
