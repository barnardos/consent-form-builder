import sortAgainst from "./sort-against";

describe("sortAgainst", () => {
  describe("items in an array are out of order with respect to a hash", () => {
    let array;
    let hash;
    beforeEach(() => {
      array = ["video", "other", "voice"];
      hash = {
        voice: "text",
        video: "text",
        some_other_value: "text"
      };
    });
    it('sorts them into the order in the hash, but "other" comes last', () => {
      expect(sortAgainst(array, hash)).to.eql(["voice", "video", "other"]);
    });
  });
});
