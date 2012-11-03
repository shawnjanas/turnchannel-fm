require 'spec_helper'

describe "mixes/new" do
  before(:each) do
    assign(:mix, stub_model(Mix).as_new_record)
  end

  it "renders new mix form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mixes_path, :method => "post" do
    end
  end
end
