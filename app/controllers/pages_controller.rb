class PagesController < ApplicationController

    def search  
        if params[:search].blank?  
            redirect_to browse_filter_path 
        else 
            @parameter = params[:search].downcase  
            @results = Event.all.where("lower(name) like ?", "%#{@parameter}%") 
        end
    end

end