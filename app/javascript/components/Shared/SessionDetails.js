import React from "react";
import PropTypes from "prop-types";
import SessionInformation from "./SessionInformation";
import ParticipantEquipment from "./ParticipantEquipment";
import Refreshments from "./Refreshments";

function incentiveText(incentives_markup, finalPreview) {
  let incentiveText = <p>&hellip;</p>;
  if (incentives_markup) {
    incentiveText = (
      <div dangerouslySetInnerHTML={{ __html: incentives_markup }} />
    );
  } else if (finalPreview) {
    incentiveText = <span />;
  }
  return incentiveText;
}

function expensesText(expenses_markup, finalPreview) {
  let expensesText = <p>&hellip;</p>;
  if (expenses_markup) {
    expensesText = (
      <div dangerouslySetInnerHTML={{ __html: expenses_markup }} />
    );
  } else if (finalPreview) {
    expensesText = <span />;
  }
  return expensesText;
}

const SessionDetails = props => {
  return (
    <section className={props.finalPreview ? "" : "reactive-preview__section"}>
      <h3
        className={props.finalPreview ? "" : "reactive-preview__heading"}
        id="session"
      >
        Session details
      </h3>

      <SessionInformation {...props} />
      {incentiveText(props.incentives_markup, props.finalPreview)}
      <ParticipantEquipment {...props} />
      {expensesText(props.expenses_markup, props.finalPreview)}
      <Refreshments {...props} />
    </section>
  );
};

SessionDetails.propTypes = {
  you_or_your_child: PropTypes.string,
  when_text: PropTypes.string,
  duration: PropTypes.string,
  location: PropTypes.string,
  participant_equipment: PropTypes.string,
  food_provided: PropTypes.string,
  incentives_markup: PropTypes.string,
  expenses_markup: PropTypes.string,
  finalPreview: PropTypes.bool
};

export default SessionDetails;
