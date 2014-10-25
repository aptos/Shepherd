class TasksController < ApplicationController
  respond_to :json

  def index
    @tasks = site.tasks.by_status.key("Open").all
    render :json => @tasks
  end

  def stats
    @stats = Hash.new
    site.tasks.by_status.reduce.group_level(2).rows.map{|r| @stats[r['key']] = r['value'] }
    render :json => @stats
  end

  def show
    @task = site.tasks.find(params[:id])
    unless @task
      render :json => { error: "Task not found: #{params[:id]}" }, :status => 404 and return
    end
    render :json => @task
  end

  def summary
    @tasks = site.tasks.by_owner.key(params[:id])
    render :json => @tasks
  end
end