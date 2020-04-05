class PagesController < ApplicationController

    def search  
        if params[:search].blank?  
            redirect_to(root_path, alert: "Type in a keyword to search for an event") and return  
        else 
            @parameter = params[:search].downcase  
            @results = Event.all.where("lower(name) like ?", "%#{@parameter}%") 
        end
    end

end