require 'spec_helper'

describe "mixes/edit" do
  before(:each) do
    @mix = assign(:mix, stub_model(Mix))
  end

  it "renders the edit mix form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mixes_path(@mix), :method => "post" do
    end
  end
end
