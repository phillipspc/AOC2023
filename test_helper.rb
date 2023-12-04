module TestHelper
  def test_works_with_sample_input
    assert_equal described_class.test, described_class::SAMPLE_OUTPUT
  end

  private

  def described_class
    Object.const_get(self.class_name.gsub("Test", ""))
  end
end
