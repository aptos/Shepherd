class CompaniesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @companies = site.companies.by_name.rows.map{|r| {id: r['id'], name: r['key']} }

    render :json => @companies
  end

  def locations
    @companies = site.companies.locations.rows.map do |r|
      if r['value']['locations'].class == Array
        locations = r['value']['locations'].map {|office| { city: office['address']['city'], latLng: office['lat_long']} }
      end
      { id: r['id'], name: r['key'], logo: r['value']['logo'], website: r['value']['website_url'], locations: locations }
    end

    render :json => @companies
  end

  def show
    @company = site.companies.find(params[:id])
    unless @company
      render :json => { error: "Company not found: #{params[:id]}" }, :status => 404 and return
    end
    render :json => @company
  end

end