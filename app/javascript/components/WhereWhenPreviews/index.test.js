import React from "react";
import WhereWhenPreviews from "./index.js";

describe("WhereWhenPreviews", () => {
  let props;
  let mountedWhereWhenPreviews;
  const whereWhenPreviews = () => {
    if (!mountedWhereWhenPreviews) {
      mountedWhereWhenPreviews = mount(<WhereWhenPreviews {...props} />);
    }
    return mountedWhereWhenPreviews;
  };

  beforeEach(() => {
    props = {
      where_when_enabled: true,
      when_text: undefined,
      duration: undefined,
      location: undefined,
      participant_equipment: undefined,
      food_provided: undefined,
      edit_links: {}
    };
    mountedWhereWhenPreviews = undefined;
  });

  describe("'yes' has been selected", () => {
    it("renders as many sections as areas on the preview that could change", () => {
      const sections = whereWhenPreviews().find("section");
      expect(sections.length).to.eql(1);
    });

    it("has blank outputs", () => {
      whereWhenPreviews()
        .find("output")
        .forEach(output => expect(output.text()).to.be.empty);
    });
  });

  describe("'no' has been selected", () => {
    beforeEach(() => {
      props = {
        where_when_enabled: false
      };
    });
    it("doesn't render any sections", () => {
      const sections = whereWhenPreviews().find("section");
      expect(sections.length).to.eql(0);
    });
  });

  describe("the initial render state", () => {
    describe("props for the finalPreview are given", () => {
      beforeEach(() => {
        props = {
          where_when_enabled: true,
          finalPreview: true,
          you_or_your_child: "You",
          when_text: "2nd of November, 2018",
          duration: "2 hours",
          location: "Euston Station",
          participant_equipment: "pencils",
          food_provided: "light lunch",
          editLinks: {
            when_text: "/rails/path/to/when_text",
            location: "/rails/path/to/location",
            duration: "/rails/path/to/duration",
            participant_equipment: "/rails/path/to/participant_equipment",
            food_provided: "/rails/path/to/food_provided"
          }
        };
      });

      it("renders an editLink with the supplied rails route for 'When'", () => {
        expect(whereWhenPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/when_text">
            2nd of November, 2018
          </a>
        );
      });
      it("renders an editLink with the supplied rails route for location", () => {
        expect(whereWhenPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/location">
            Euston Station
          </a>
        );
      });
      it("renders an editLink with the supplied rails route for duration", () => {
        expect(whereWhenPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/duration">
            2 hours
          </a>
        );
      });
      it("renders an editLink with the supplied rails route for participant equipment", () => {
        expect(whereWhenPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/participant_equipment">
            pencils
          </a>
        );
      });
      it("renders an editLink with the supplied rails route for food provided", () => {
        expect(whereWhenPreviews()).to.contain(
          <a className="editable" href="/rails/path/to/food_provided">
            light lunch
          </a>
        );
      });
      it("renders the session details", () => {
        expect(whereWhenPreviews().text()).to.contain(
          `When: ${props.when_text}`
        );
        expect(whereWhenPreviews().text()).to.contain(
          `Where: ${props.location}`
        );
        expect(whereWhenPreviews().text()).to.contain(
          `Duration: ${props.duration}`
        );
      });
      it("renders the equipment needed into a readable sentence", () => {
        expect(whereWhenPreviews().text()).to.contain(
          `You will need to bring ${props.participant_equipment}`
        );
      });
      it("renders the food provided into a readable sentence", () => {
        expect(whereWhenPreviews().text()).to.contain(
          `${props.food_provided} will be provided.`
        );
      });
    });
  });

  describe("values changing", () => {
    describe("the location changing", () => {
      beforeEach(() => {
        props = {
          where_when_enabled: true,
          location: "Euston Station"
        };
      });

      describe("receipt of an input change", () => {
        it("changes the location", () => {
          whereWhenPreviews()
            .instance()
            .handleTextOrRadioChange({
              target: {
                name: "research_session[location]",
                value: "Russell Square"
              }
            });

          expect(
            whereWhenPreviews()
              .find('output[data-field="location"]')
              .first()
              .text()
          ).to.eql("Russell Square");
        });
      });
    });
  });
});
