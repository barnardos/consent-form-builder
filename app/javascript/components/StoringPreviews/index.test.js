import React from "react";
import StoringPreviews from "./index.js";

describe("StoringPreviews", () => {
  let props;
  let mountedStoringPreviews;
  const storingPreviews = () => {
    if (!mountedStoringPreviews) {
      mountedStoringPreviews = mount(<StoringPreviews {...props} />);
    }
    return mountedStoringPreviews;
  };

  beforeEach(() => {
    props = {
      shared_duration: undefined,
      shared_with: undefined,
      shared_with_sentences: undefined,
      finalPreview: false
    };
    mountedStoringPreviews = undefined;
  });

  describe("the initial render state", () => {
    describe("no props are given", () => {
      it("renders a section as an area on the preview that could change", () => {
        const sections = storingPreviews().find("section");
        expect(sections.length).to.eql(1);
      });

      it("has two outputs, which are blank", () => {
        const outputs = storingPreviews().find("output");
        expect(outputs.length).to.equal(2);
        outputs.forEach(output => expect(output.text()).to.be.empty);
      });
    });

    describe("a radio button is selected and a year has been added", () => {
      beforeEach(() => {
        props = {
          shared_duration: "one year",
          shared_with: "anonymised",
          shared_with_sentences: {
            anonymised: "anonymised sentence"
          },
          editLinks: {
            shared_duration: "/path/to/rails/storing"
          },
          finalPreview: true
        };
        mountedStoringPreviews = undefined;
      });

      it("displays the shared duration content", () => {
        const sharedDurationOutput = storingPreviews().find(
          'output[data-field="shared_duration"]'
        );
        expect(sharedDurationOutput)
          .text()
          .to.eql(props.shared_duration);
      });

      it("displays the shared_with sentence", () => {
        const sharedWithOutput = storingPreviews().find(
          'output[data-field="shared_with"]'
        );
        expect(sharedWithOutput)
          .text()
          .to.eql(props.shared_with_sentences.anonymised);
      });
    });
  });

  describe("values changing", () => {
    beforeEach(() => {
      props = {
        shared_duration: "one year",
        shared_with: "anonymised",
        shared_with_sentences: {
          anonymised: "anonymised sentence",
          internal: "internal sentence"
        },
        finalPreview: false
      };
    });

    describe("receipt of an input change", () => {
      it("changes the shared duration", () => {
        storingPreviews()
          .instance()
          .handleTextOrRadioChange({
            target: {
              name: "research_session[shared_duration]",
              value: "two years"
            }
          });

        expect(
          storingPreviews()
            .find('output[data-field="shared_duration"]')
            .text()
        ).to.eql("two years");
      });

      it("changes the shared with sentence", () => {
        storingPreviews()
          .instance()
          .handleTextOrRadioChange({
            target: { name: "research_session[shared_with]", value: "internal" }
          });

        expect(
          storingPreviews()
            .find('output[data-field="shared_with"]')
            .text()
        ).to.eql(props.shared_with_sentences.internal);
      });
    });
  });
});
