require 'helper'

class TestFeatureQuantifications < Test::Unit::TestCase

  def test_initialize()
    fq = FeatureQuantifications.new("test/data/feature_quantifications_RUM2654-JDL-10")
    assert_equal(fq.filename,"test/data/feature_quantifications_RUM2654-JDL-10")
    assert_equal(fq.index_filename,"test/data/feature_quantifications_RUM2654-JDL-10.idx")
    assert_equal(fq.index,nil)
    assert_raise RuntimeError do
      fq = FeatureQuantifications.new("test/data/feature_quantifications_RUM2654-JDL-XYZ")
    end
  end

  def test_save_index()
    fq = FeatureQuantifications.new("test/data/feature_quantifications_RUM2654-JDL-10")
    fq.save_index()
    assert_equal(fq.index_filename,"test/data/feature_quantifications_RUM2654-JDL-10.idx")
    assert_equal(fq.index,nil)
    assert_raise RuntimeError do
      fq = FeatureQuantifications.new("test/data/feature_quantifications_RUM2654-JDL-XYZ")
    end
  end

end