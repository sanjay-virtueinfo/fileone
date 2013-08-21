class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_admin
  before_action :set_header_menu_active
  # GET /features
  # GET /features.json
  def index
    @o_all = get_records(params[:feature], params[:page])
  end
  
  # GET /features/1
  # GET /features/1.json
  def show
  end

  # GET /features/new
  def new
    @o_single = Feature.new
  end

  # GET /features/1/edit
  def edit
  end

  # POST /features
  # POST /features.json
  def create
    @o_single = Feature.new(feature_params)

    respond_to do |format|
      if @o_single.save        
        format.html { redirect_to features_url, notice: t("general.successfully_created") }
        format.json { render action: 'show', status: :created, location: @o_single }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /features/1
  # PATCH/PUT /features/1.json
  def update
    respond_to do |format|
      if @o_single.update_attributes(feature_params)
        format.html { redirect_to features_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to features_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @o_single = Feature.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit!
    end
    
    def get_records(search, page)
      feature_query = Feature.scoped
      feature_query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
    end    
    
    def set_header_menu_active
      @features = true
    end
    
    def sort_column
      Feature.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end       
end
