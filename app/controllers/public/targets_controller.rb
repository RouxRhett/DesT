class Public::TargetsController < ApplicationController
  before_action :user_login_check

  def index
    @categories = Category.all
    if params[:filter]
      @cat_id = params[:filter]
    else
      @cat_id = nil
    end

    case params[:filter_type]
    when 'true'
      @filter_type = true
      @tab1 = ' active'
    when 'false'
      @filter_type = false
      @tab0 = ' active'
    else
      @filter_type = true
      @tab1 = ' active'
    end

    if @cat_id
      @targets = Target.where(completion_status: @filter_type, category_id: @cat_id).order(:deadline)
      @category_name = Category.find(@cat_id).name
    else
      @targets = Target.where(completion_status: @filter_type).order(:deadline)
      @category_name = '全て'
    end
  end

  def new
    # 新規登録用のインスタンス変数
    @target = Target.new
  end

  def create
    @target = Target.new(target_params)
    @target.user_id = current_user.id
    if @target.save
      achievement_check('target_create')
      flash[:notice] = '保存成功' # 後で変える TODO
      redirect_to target_path(@target)
    else
      flash[:notice] = '保存失敗' # 後で変える TODO
      # indexが存在せず、renderで対応すると失敗後リロードでエラーが出る為
      redirect_to new_target_path
    end
  end

  def show
    @target = Target.find(params[:id])
    @task = Task.new
    @tasks = @target.tasks
  end

  def edit
    @target = Target.find(params[:id])
    if @target.user == current_user
      render 'edit'
    else
      flash[:notice] = '権限がありません'
      redirect_to mypage_path
    end
  end

  def update
    @target = Target.find(params[:id])
    if @target.user == current_user
      if @target.update(target_params)
        redirect_to target_path(@target)
      else
        flash[:notice] = '更新失敗' # 後で変える TODO
        render 'edit'
      end
    else
      flash[:notice] = '権限がありません'
      redirect_to mypage_path
    end
  end

  def destroy
    target = Target.find(params[:id])
    target.destroy
    redirect_to mypage_path
  end

  def error
  end

  def confirm
    @target = Target.find(params[:id])
  end

  def complete
    @target = Target.find(params[:id])
    @target.update(completion_status: true)
    achievement_check('target_complete')
  end

  private

  def target_params
    params.require(:target).permit(
      :category_id, :goal, :reason, :deadline, :completion_status, :public_status
    )
  end
end
