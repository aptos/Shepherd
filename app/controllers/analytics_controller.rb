class AnalyticsController < ApplicationController
  respond_to :json

  def search
    @searches = site.analytics.searches.reduce.group_level(1).rows.sort_by{|s| s['value']}.reverse

    if params[:format] == "csv"
      search_map = @searches.map{|s| [s['key'], s['value']]}
      search_map.unshift ['search term','count']
      render text: search_map.simple_csv
    else
      render :json => @searches
    end
  end

  def views
    companies = site.companies.summary.values.sort_by{|c| c['views']}.reverse.map{|c| c.slice('name','views')}

    if params[:format] == "csv"
      companies_map = companies.map{|s| [s['name'], s['views']]}
      companies_map.unshift ['company','views']
      render text: companies_map.simple_csv
    else
      render :json => companies
    end
  end

end