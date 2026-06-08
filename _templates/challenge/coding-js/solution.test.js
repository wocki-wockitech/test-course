import { describe, it, expect } from "vitest";
import { sumTwo } from "./solution.js";

describe("sumTwo", () => {
  it("adds positive numbers", () => {
    expect(sumTwo(2, 3)).toBe(5);
  });

  it("adds negative numbers", () => {
    expect(sumTwo(-1, -1)).toBe(-2);
  });

  it("handles zero", () => {
    expect(sumTwo(0, 0)).toBe(0);
  });

  it("handles floats", () => {
    expect(sumTwo(1.5, 2.5)).toBe(4);
  });
});
