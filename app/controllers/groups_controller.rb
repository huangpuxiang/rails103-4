class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :new, :create, :destroy]
  before_action :find_group_and_check_permisson, only: [:edit, :update, :destroy]
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
      flash[:notice] = "群组更新成功"
    else
      render :edit
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, alert: "删除成功！"
  end

  private

  def find_group_and_check_permisson
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to groups_path, alert: "you have no permission"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
