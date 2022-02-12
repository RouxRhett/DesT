class Public::TasksController < ApplicationController
  before_action :user_login_check

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_back(fallback_location:root_path)
    else
      redirect_back(fallback_location:root_path)
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_back(fallback_location:root_path)
  end

  private

  def task_params
    params.require(:task).permit(
      :target_id, :name, :time
    )
  end
end