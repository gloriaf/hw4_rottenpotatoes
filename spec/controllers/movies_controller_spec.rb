require 'spec_helper'

describe MoviesController do
  describe 'add director to existing movie, and  fill in "Director" with "Ridley Scott"' do
    it 'should call update_attributes and redirect" ' do
      @m=mock(Movie, :title => "Alien", :id => "4")
      Movie.stub!(:find).with("4").and_return(@m)
      @m.stub!(:update_attributes!).and_return(true)
      put :update, {:id => "4", :movie => @m}
      response.should redirect_to(movie_path(@m))
    end
  end
  
  describe 'find movie with same director' do
    before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "George Lucas", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
    end
    it 'should be on the Similar Movies page for "Star Wars"' do
      { :post => movie_similar_path(1) }.
      should route_to(:controller => "movies", :action => "similar", :movie_id => "1")
    end
    it 'should call the model method that finds similar movies' do
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:similar_directors).with('George Lucas').and_return(fake_results)
      get :similar, :movie_id => "1"
    end
    it 'should select the Similar template for rendering and make results available' do
      Movie.stub!(:similar_directors).with('George Lucas').and_return(@m)
      get :similar, :movie_id => "1"
      response.should render_template('similar')
      assigns(:movies).should == @m
    end
  end
  
  describe 'sad path' do
    before :each do
      m=mock(Movie, :title => "Star Wars", :director => nil, :id => "1")
      Movie.stub!(:find).with("1").and_return(m)
    end
    
    it 'should generate routing for Similar Movies' do
      { :post => movie_similar_path(1) }.
      should route_to(:controller => "movies", :action => "similar", :movie_id => "1")
    end
    it 'should select the Index template for rendering and generate a flash' do
      get :similar, :movie_id => "1"
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end
end



