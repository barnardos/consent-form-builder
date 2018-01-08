import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";

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
  let sessionTime = <span />;
  if (props.when_text || !props.finalPreview) {
    sessionTime = <p>When: {Output(props, "when_text")}</p>;
  }

  let sessionLocation = <span />;
  if (props.location || !props.finalPreview) {
    sessionLocation = <p>Where: {Output(props, "location")}</p>;
  }

  let sessionDuration = <span />;
  if (props.duration || !props.finalPreview) {
    sessionDuration = <p>Duration: {Output(props, "duration")}</p>;
  }

  let participantEquipmentSentence;
  if (props.participant_equipment || !props.finalPreview) {
    participantEquipmentSentence = (
      <p>
        {props.you_or_your_child} will need to bring{" "}
        {Output(props, "participant_equipment")}.
      </p>
    );
  }

  let foodText = <span />;
  if (props.food_provided || !props.finalPreview) {
    foodText = <p>{Output(props, "food_provided")} will be provided.</p>;
  }

  return (
    <section className={props.finalPreview ? "" : "reactive-preview__section"}>
      <h3
        className={props.finalPreview ? "" : "reactive-preview__heading"}
        id="session"
      >
        Session details
      </h3>

      {sessionTime}
      {sessionLocation}
      {sessionDuration}
      {incentiveText(props.incentives_markup, props.finalPreview)}
      {participantEquipmentSentence}
      {expensesText(props.expenses_markup, props.finalPreview)}
      {foodText}
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
