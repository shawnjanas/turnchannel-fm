require 'spec_helper'

describe "mixes/show" do
  before(:each) do
    @mix = assign(:mix, stub_model(Mix))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
