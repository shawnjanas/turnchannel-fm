require "spec_helper"

describe MixesController do
  describe "routing" do

    it "routes to #index" do
      get("/mixes").should route_to("mixes#index")
    end

    it "routes to #new" do
      get("/mixes/new").should route_to("mixes#new")
    end

    it "routes to #show" do
      get("/mixes/1").should route_to("mixes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/mixes/1/edit").should route_to("mixes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/mixes").should route_to("mixes#create")
    end

    it "routes to #update" do
      put("/mixes/1").should route_to("mixes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/mixes/1").should route_to("mixes#destroy", :id => "1")
    end

  end
end
