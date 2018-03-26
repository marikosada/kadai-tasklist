class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @tasks = Task.all
    set_logged_in?
  end
  
  def show
  end
  
  def new
    @task = Task.new
    set_logged_in?
  end

  def create
    @task = current_user.tasks.build(task_params)
    correct_user
    if @task.save
      flash[:success] = '正常に投稿できました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order('created_at DESC')
      flash.now[:danger]= '投稿できませんでした'
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash[:danger] = 'タスクは更新できませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = 'タスクは正常に削除されました'
    redirect_to tasks_url
  end
  
  private
    def task_params
      params.require(:task).permit(:content, :status)
    end
    
    def set_task
      @task = Task.find(params[:id])
    end
    
    def correct_user
      @dask = current_user.tasks.find_by(id: params[:id])
      unless @task
        flash[:danger] = '自分自身のタスクのみ操作可能です'
        redirect_to root_url
      end
    end
    
    def set_logged_in?
      if logged_in?
        @user = current_user
        @task = current_user.tasks.build
        @tasks = current_user.tasks.order('created_at DESC')
      end
    end
end
