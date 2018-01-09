import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";

const Refreshments = props => {
  const { food_provided, finalPreview } = props;
  let foodText = <span />;
  if (food_provided || !finalPreview) {
    foodText = <p>{Output(props, "food_provided")} will be provided.</p>;
  }

  return <div>{foodText}</div>;
};

Refreshments.propTypes = {
  food_provided: PropTypes.string,
  finalPreview: PropTypes.bool
};

export default Refreshments;
