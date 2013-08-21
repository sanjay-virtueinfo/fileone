class UserPlansController < ApplicationController
  before_action :set_user_plan, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_admin
  before_action :set_header_menu_active
  # GET /user_plans
  # GET /user_plans.json
  def index
    @o_all = get_records(params[:user_plan], params[:page])
  end
  
  # GET /user_plans/1
  # GET /user_plans/1.json
  def show
  end

  # GET /user_plans/new
  def new
    @o_single = UserPlan.new
  end

  # GET /user_plans/1/edit
  def edit
  end

  # POST /user_plans
  # POST /user_plans.json
  def create
    @o_single = UserPlan.new(user_plan_params)

    respond_to do |format|
      if @o_single.save        
        format.html { redirect_to user_plans_url, notice: t("general.successfully_created") }
        format.json { render action: 'show', status: :created, location: @o_single }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_plans/1
  # PATCH/PUT /user_plans/1.json
  def update
    respond_to do |format|
      if @o_single.update_attributes(user_plan_params)
        format.html { redirect_to user_plans_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_plans/1
  # DELETE /user_plans/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to user_plans_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_plan
      @o_single = UserPlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_plan_params
      params.require(:user_plan).permit!
    end
    
    def get_records(search, page)
      user_plan_query = UserPlan.scoped
      user_plan_query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
    end    
    
    def set_header_menu_active
      @user_plans = true
    end
    
    def sort_column
      UserPlan.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end       
end
