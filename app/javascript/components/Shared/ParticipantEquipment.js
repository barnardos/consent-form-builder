import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";

const ParticipantEquipment = props => {
  const { participant_equipment, finalPreview, you_or_your_child } = props;
  let participantEquipmentSentence;
  if (participant_equipment || !finalPreview) {
    participantEquipmentSentence = (
      <p>
        {you_or_your_child} will need to bring{" "}
        {Output(props, "participant_equipment")}.
      </p>
    );
  }

  return <div>{participantEquipmentSentence}</div>;
};

ParticipantEquipment.propTypes = {
  you_or_your_child: PropTypes.string,
  participant_equipment: PropTypes.string,
  finalPreview: PropTypes.bool
};

export default ParticipantEquipment;
