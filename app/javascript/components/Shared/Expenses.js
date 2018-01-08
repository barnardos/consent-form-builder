import humanizeList from "humanize-list";
import React from "react";
import PropTypes from "prop-types";
import Output from "./Output";

function formatCurrency(value) {
  return new Intl.NumberFormat("en-GB", {
    style: "currency",
    currency: "GBP"
  }).format(value);
}

function expenseSentence(travel, food, other) {
  const expenses = [
    { value: travel, sentence: "travel expenses of up to" },
    { value: food, sentence: "food expenses of up to" },
    { value: other, sentence: "other expenses of up to" }
  ];

  return humanizeList(
    expenses
      .filter(expense => parseInt(expense.value, 10))
      .map(({ value, sentence }) => `${sentence} ${formatCurrency(value)}`),
    {
      oxfordComma: true
    }
  );
}

const Expenses = props => {
  const {
    receipts_required,
    travel_expenses_limit,
    food_expenses_limit,
    other_expenses_limit
  } = props;

  let receiptsRequiredText = <span />;
  if (JSON.parse(receipts_required)) {
    receiptsRequiredText = (
      <p>{Output(props, "receipts_required", "Receipts must be provided.")}</p>
    );
  }

  return (
    <div>
      <p>
        {Output(
          props,
          "travel_expenses_limit",
          `We allow ${expenseSentence(
            travel_expenses_limit,
            food_expenses_limit,
            other_expenses_limit
          )}.`
        )}
      </p>
      {receiptsRequiredText}
    </div>
  );
};

Expenses.propTypes = {
  receipts_required: PropTypes.string,
  travel_expenses_limit: PropTypes.string,
  food_expenses_limit: PropTypes.string,
  other_expenses_limit: PropTypes.string,
  finalPreview: PropTypes.bool
};

export default Expenses;
