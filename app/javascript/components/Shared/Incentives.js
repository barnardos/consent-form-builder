import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";

function formatCurrency(value) {
  return new Intl.NumberFormat("en-GB", {
    style: "currency",
    currency: "GBP"
  }).format(value);
}

const Incentives = props => {
  const {
    incentive_value,
    payment_type,
    you_or_your_child,
    you_or_they,
    your_or_your_childs
  } = props;
  return (
    <div>
      <p>
        {your_or_your_childs} time and what {you_or_they} say is really
        important to us.
      </p>
      <p>
        As a thank you, we will give {you_or_your_child}{" "}
        {Output(
          props,
          "payment_type",
          payment_type === "cash"
            ? "a cash incentive of"
            : "vouchers to the value of"
        )}{" "}
        {Output(props, "incentive_value", formatCurrency(incentive_value))}.
        {payment_type === "voucher"
          ? Output(
              props,
              "payment_type",
              " They can be used in many high street shops."
            )
          : ""}
      </p>
    </div>
  );
};

Incentives.propTypes = {
  incentive_value: PropTypes.string,
  payment_type: PropTypes.string,
  you_or_your_child: PropTypes.string,
  you_or_they: PropTypes.string,
  your_or_your_childs: PropTypes.string,
  finalPreview: PropTypes.bool
};

export default Incentives;
