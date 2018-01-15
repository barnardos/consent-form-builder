import React from "react";
import IncentivesPreviews from "./index.js";

describe("IncentivesPreviews", () => {
  let props;
  let mountedIncentivesPreviews;
  const incentivesPreviews = () => {
    if (!mountedIncentivesPreviews) {
      mountedIncentivesPreviews = mount(<IncentivesPreviews {...props} />);
    }
    return mountedIncentivesPreviews;
  };

  beforeEach(() => {
    props = {
      you_or_they: undefined,
      your_or_your_childs: undefined,
      incentive_value: undefined,
      payment_type: undefined,
      you_or_your_child: undefined,
      edit_links: {}
    };
    mountedIncentivesPreviews = undefined;
  });

  describe("the initial render state", () => {
    describe("props for the finalPreview are given", () => {
      beforeEach(() => {
        props = {
          you_or_they: "you",
          your_or_your_childs: "Your",
          incentive_value: "10",
          payment_type: "cash",
          you_or_your_child: "you",
          finalPreview: true,
          editLinks: {
            incentive_value: "/rails/path/to/incentive_value",
            payment_type: "/rails/path/to/payment_type"
          }
        };
      });

      it("renders an editLink with the supplied rails route for Incentives", () => {
        expect(
          incentivesPreviews()
            .find(".editable")
            .first()
        ).to.attr("href", "/rails/path/to/payment_type");

        expect(
          incentivesPreviews()
            .find(".editable")
            .at(1)
        ).to.attr("href", "/rails/path/to/incentive_value");
      });

      it("renders the cash incentive provided into a readable sentence", () => {
        expect(incentivesPreviews().text()).to.contain(
          `As a thank you, we will give you a cash incentive of £10.00`
        );
      });

      it("renders the voucher incentive provided into a readable sentence", () => {
        props.payment_type = "voucher";
        expect(incentivesPreviews().text()).to.contain(
          `As a thank you, we will give you vouchers to the value of £10.00. They can be used in many high street shops.`
        );
      });
    });
  });

  describe("values changing", () => {
    beforeEach(() => {
      props = {
        you_or_they: "you",
        your_or_your_childs: "Your",
        incentive_value: "10",
        payment_type: "cash",
        you_or_your_child: "you",
        finalPreview: true,
        editLinks: {
          incentive_value: "/rails/path/to/incentive_value"
        }
      };
    });

    it("changes the value provided", () => {
      incentivesPreviews()
        .instance()
        .handleTextOrRadioChange({
          target: {
            name: "research_session[incentive_value]",
            value: "20"
          }
        });

      expect(
        incentivesPreviews()
          .find('output[data-field="incentive_value"]')
          .first()
          .text()
      ).to.eql("£20.00");
    });

    it("changes the incentive type", () => {
      incentivesPreviews()
        .instance()
        .handleTextOrRadioChange({
          target: {
            name: "research_session[payment_type]",
            value: "voucher"
          }
        });

      expect(
        incentivesPreviews()
          .find('output[data-field="payment_type"]')
          .first()
          .text()
      ).to.eql("vouchers to the value of");
    });
  });
});
