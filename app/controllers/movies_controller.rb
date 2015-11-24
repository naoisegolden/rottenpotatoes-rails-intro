class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    if params[:sort_by]
      session[:sort_by] = sort_by = params[:sort_by]
    else
      sort_by = session[:sort_by] || 'title'
    end
    
    if params[:ratings]
      session[:ratings] = ratings = params[:ratings]
    else
      ratings = session[:ratings] || @all_ratings
    end
    
    if !params[:sort_by] || !params[:ratings]
      redirect_to movies_path(ratings: ratings, sort_by: sort_by)
    end
    
    @selected_ratings = @all_ratings
    @movies = Movie.all
  
    if ratings
      @selected_ratings = ratings
      @movies = Movie.where(rating: Array(ratings))
    end
  
    if sort_by
      @movies = @movies.order(sort_by)
    end
  
    @title_class = 'hilite' if sort_by == 'title'
    @release_date_class = 'hilite' if sort_by == 'release_date'
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
