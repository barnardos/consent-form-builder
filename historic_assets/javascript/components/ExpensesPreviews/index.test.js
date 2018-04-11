import React from "react";
import ExpensesPreviews from "./index.js";

describe("ExpensesPreviews", () => {
  let props;
  let mountedExpensesPreviews;
  const expensesPreviews = () => {
    if (!mountedExpensesPreviews) {
      mountedExpensesPreviews = mount(<ExpensesPreviews {...props} />);
    }
    return mountedExpensesPreviews;
  };

  beforeEach(() => {
    props = {
      expenses_enabled: true,
      travel_expenses_limit: undefined,
      food_expenses_limit: undefined,
      other_expenses_limit: undefined,
      receipts_required: false,
      edit_links: {}
    };
    mountedExpensesPreviews = undefined;
  });

  describe("the initial render state", () => {
    describe("props for the finalPreview are given", () => {
      beforeEach(() => {
        props = {
          travel_expenses_limit: "5",
          food_expenses_limit: "10",
          other_expenses_limit: "15",
          receipts_required: "true",
          finalPreview: true,
          editLinks: {
            travel_expenses_limit: "/rails/path/to/travel_expenses_limit",
            receipts_required: "/rails/path/to/receipts_required"
          }
        };
      });

      it("renders an editLink with the supplied rails route for Expenses", () => {
        expect(
          expensesPreviews()
            .find(".editable")
            .first()
        ).to.attr("href", "/rails/path/to/travel_expenses_limit");
      });

      it("renders an editLink with the supplied rails route for 'Receipts Required'", () => {
        expect(expensesPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/receipts_required">
            Receipts must be provided.
          </a>
        );
      });

      it("renders the expenses used into a readable sentence", () => {
        expect(expensesPreviews().text()).to.contain(
          `We allow travel expenses of up to £5.00, food expenses of up to £10.00, and other expenses of up to £15.00.`
        );
      });
    });
  });

  describe("values changing", () => {
    describe("the location changing", () => {
      beforeEach(() => {
        props = {
          expenses_enabled: true,
          travel_expenses_limit: "2.00",
          receipts_required: "true"
        };
      });

      describe("receipt of an input change", () => {
        it("adds an additional expense", () => {
          expensesPreviews()
            .instance()
            .handleTextOrRadioChange({
              target: {
                name: "research_session[food_expenses_limit]",
                value: "10.00"
              }
            });

          expect(
            expensesPreviews()
              .find('output[data-field="travel_expenses_limit"]')
              .first()
              .text()
          ).to.eql(
            "We allow travel expenses of up to £2.00, and food expenses of up to £10.00."
          );
        });

        it("changes the travel expenses limit", () => {
          expensesPreviews()
            .instance()
            .handleTextOrRadioChange({
              target: {
                name: "research_session[travel_expenses_limit]",
                value: "20.00"
              }
            });

          expect(
            expensesPreviews()
              .find('output[data-field="travel_expenses_limit"]')
              .first()
              .text()
          ).to.eql("We allow travel expenses of up to £20.00.");
        });

        it("changes that receipts are required", () => {
          expensesPreviews()
            .instance()
            .handleTextOrRadioChange({
              target: {
                name: "research_session[receipts_required]",
                value: "false"
              }
            });

          expect(expensesPreviews()).not.to.contain(
            <a className="editable" href="/rails/path/to/receipts_required">
              Receipts must be provided.
            </a>
          );
        });
      });
    });
  });
});
