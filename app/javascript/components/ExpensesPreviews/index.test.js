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
      receipts_required: undefined,
      edit_links: {}
    };
    mountedExpensesPreviews = undefined;
  });

  describe("'yes' has been selected", () => {
    it("renders as many sections as areas on the preview that could change", () => {
      const sections = expensesPreviews().find("section");
      expect(sections.length).to.eql(1);
    });

    it("has blank outputs", () => {
      expensesPreviews()
        .find("output")
        .forEach(output => expect(output.text()).to.be.empty);
    });
  });

  describe("'no' has been selected", () => {
    beforeEach(() => {
      props = {
        expenses_enabled: false
      };
    });
    it("doesn't render any sections", () => {
      const sections = expensesPreviews().find("section");
      expect(sections.length).to.eql(0);
    });
  });

  describe("the initial render state", () => {
    describe("props for the finalPreview are given", () => {
      beforeEach(() => {
        props = {
          expenses_enabled: true,
          travel_expenses_limit: "5.00",
          food_expenses_limit: "10.00",
          other_expenses_limit: "15.00",
          receipts_required: "true",
          edit_links: {
            travel_expenses_limit: "/rails/path/to/travel_expenses_limit",
            food_expenses_limit: "/rails/path/to/food_expenses_limit",
            other_expenses_limit: "/rails/path/to/other_expenses_limit",
            receipts_required: "/rails/path/to/receipts_required"
          }
        };
      });

      it("renders an editLink with the supplied rails route for 'Travel Expenses Limit'", () => {
        expect(expensesPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/travel_expenses_limit">
            5.00
          </a>
        );
      });
      it("renders an editLink with the supplied rails route for 'Food Expenses Limit'", () => {
        expect(expensesPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/food_expenses_limit">
            15.00
          </a>
        );
      });
      it("renders an editLink with the supplied rails route for 'Other Expenses Limit'", () => {
        expect(expensesPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/other_expenses_limit">
            15.00
          </a>
        );
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
          travel_expenses_limit: "2.00"
        };
      });

      describe("receipt of an input change", () => {
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
              .find('output[data-field="location"]')
              .first()
              .text()
          ).to.eql("20.00");
        });
      });
    });
  });
});
