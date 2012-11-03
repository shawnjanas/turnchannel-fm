require 'spec_helper'

describe "mixes/index" do
  before(:each) do
    assign(:mixes, [
      stub_model(Mix),
      stub_model(Mix)
    ])
  end

  it "renders a list of mixes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
