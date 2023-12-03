module TestHelper
  def test_works_with_sample_input
    assert_equal described_class.call(described_class.sample_input),
                 described_class.sample_output
  end

  private

  def described_class
    Object.const_get(self.class_name.gsub("Test", ""))
  end
end
