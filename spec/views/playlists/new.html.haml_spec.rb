require 'spec_helper'

describe "playlists/new" do
  before(:each) do
    assign(:playlist, stub_model(Playlist).as_new_record)
  end

  it "renders new playlist form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => playlists_path, :method => "post" do
    end
  end
end
