import React from "react";
import MethodologyPreviews from "./index.js";

describe("MethodologyPreviews", () => {
  let props;
  let mountedMethodologyPreviews;
  const methodologiesPreviews = () => {
    if (!mountedMethodologyPreviews) {
      mountedMethodologyPreviews = mount(<MethodologyPreviews {...props} />);
    }
    return mountedMethodologyPreviews;
  };

  beforeEach(() => {
    props = {
      all_methodologies: undefined,
      methodologies: undefined,
      editLinks: {}
    };
    mountedMethodologyPreviews = undefined;
  });

  describe("the initial render state", () => {
    describe("no props are given", () => {
      it("renders as many sections as areas on the preview that could change", () => {
        const sections = methodologiesPreviews().find("section");
        expect(sections.length).to.eql(1);
      });

      it("has at least one output, which will be blank", () => {
        const outputs = methodologiesPreviews().find("output");
        expect(outputs.length).to.be.greaterThan(0);
        outputs.forEach(output => expect(output.text()).to.be.empty);
      });
    });

    describe("three boxes are checked in the final preview", () => {
      beforeEach(() => {
        props = {
          all_methodologies: {
            interview: "a one-on-one interview",
            usability: "looking at how you use a new tool we’re designing",
            survey: "a survey or paper questionnaire",
            focusgroup: "a group discussion",
            codesign: "a group activity",
            other: "Other"
          },
          methodologies: ["interview", "survey", "other"],
          other_methodology: "some other methodology",
          editLinks: {
            methodologies: "/path/to/rails/methodologies",
            other_methodology: "/path/to/rails/methodologies"
          },
          researcher_name: "Susan McTester",
          you_or_your_child: "your child/the child in your care",
          finalPreview: true
        };
        mountedMethodologyPreviews = undefined;
      });

      it("has a total of five outputs, one for each selected methdology and one for the researcher name", () => {
        const outputs = methodologiesPreviews().find("output");
        expect(outputs.length).to.eql(5);
      });

      it("has a li for items", () => {
        expect(methodologiesPreviews()).to.contain(
          <li>
            <output data-field="methodologies">
              <a className="editable" href="/path/to/rails/methodologies">
                a one-on-one interview
              </a>
            </output>
          </li>
        );
      });

      it('has a li for the "other" item', () => {
        expect(methodologiesPreviews()).to.contain(
          <li>
            <output data-field="other_methodology">
              <a className="editable" href="/path/to/rails/methodologies">
                some other methodology
              </a>
            </output>
          </li>
        );
      });

      it('defaults to "my child"', () => {
        expect(methodologiesPreviews().text()).to.contain(
          "would like your child/the child in your care to take part in"
        );
      });

      describe("able to give consent", () => {
        beforeEach(() => {
          props.you_or_your_child = "you";
        });

        it('removes "my child"', () => {
          expect(methodologiesPreviews().text()).to.contain(
            "would like you to take part in"
          );
        });
      });
    });
  });

  describe("values changing", () => {
    describe("the selections changing", () => {
      beforeEach(() => {
        props = {
          methodologies: ["interview", "codesign"],
          other_methodology: "The other value",
          all_methodologies: {
            interview: "a one-on-one interview",
            usability: "looking at how you use a new tool we’re designing",
            survey: "a survey or paper questionnaire",
            focusgroup: "a group discussion",
            codesign: "a group activity",
            other: "Other"
          },
          finalPreview: false
        };
      });

      describe("adding an item that is not there", () => {
        // Simulate change from a field such as
        // <input name="research_session[methodologies][]" data-previewed-by="MethodologyPreviews" />
        // - usually triggered onchange, but that link is not tested here, we're just simulating the
        //   resulting event
        beforeEach(() => {
          methodologiesPreviews()
            .instance()
            .handleCheckboxChange({
              target: {
                name: "research_session[methodologies][]",
                value: "survey",
                checked: true
              }
            });
          methodologiesPreviews().update();
        });

        it("adds that value to the list in order", () => {
          expect(methodologiesPreviews()).to.contain(
            <ul className="bullet-point-list">
              <li>
                <output
                  className="reactive-preview__highlight"
                  data-field="methodologies"
                >
                  a one-on-one interview
                </output>
              </li>
              <li>
                <output
                  className="reactive-preview__highlight"
                  data-field="methodologies"
                >
                  a survey or paper questionnaire
                </output>
              </li>
              <li>
                <output
                  className="reactive-preview__highlight"
                  data-field="methodologies"
                >
                  a group activity
                </output>
              </li>
            </ul>
          );
        });
      });

      describe('changing the "other" value', () => {
        // Simulate change from a field such as
        // <input name="research_session[other_methodology]" data-previewed-by="MethodologyPreviews" />
        // - usually triggered oninput, but that link is not tested here, we're just simulating the
        //   resulting event
        beforeEach(() => {
          props["methodologies"] = ["other"];
          methodologiesPreviews()
            .instance()
            .handleTextOrRadioChange({
              target: {
                name: "research_session[other_methodology]",
                value: "a new other value"
              }
            });
          methodologiesPreviews().update();
        });

        it("changes the value in the list", () => {
          expect(methodologiesPreviews()).to.contain(
            <output
              className="reactive-preview__highlight"
              data-field="other_methodology"
            >
              a new other value
            </output>
          );
        });
      });

      describe("removing an item that is there", () => {
        // Simulate change from a field such as
        // <input name="research_session[methodologies][]" data-previewed-by="MethodologyPreviews" />
        // - usually triggered onchange, but that link is not tested here, we're just simulating the
        //   resulting event

        it("removes that value from the list", () => {
          methodologiesPreviews()
            .instance()
            .handleCheckboxChange({
              target: {
                name: "research_session[methodologies][]",
                value: "interview",
                checked: false
              }
            });

          expect(methodologiesPreviews().text()).not.to.contain(
            "a one-on-one interview"
          );
        });
      });
    });
  });
});
