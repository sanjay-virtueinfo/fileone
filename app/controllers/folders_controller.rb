class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_user
  before_action :set_header_menu_active
  # GET /folders
  # GET /folders.json
  def index
    session[:parent_folder_id] = nil
    @o_all = current_user.folders.parent_folders
    @o_single = Folder.new
    @folder = session[:folder_temp_id] ? (Folder.find(session[:folder_temp_id])) : nil     
  end
  
  def sub_folders
    session[:parent_folder_id] = params[:parent_folder_id] if params[:parent_folder_id]
    @folder = session[:folder_temp_id] ? (Folder.find(session[:folder_temp_id])) : nil
    @o_single = Folder.new
    
    if session[:parent_folder_id]
      @o_folder = Folder.find(params[:parent_folder_id])
      if @o_folder.parent_folder.nil?
        @o_all = @o_folder.folders
      else
        @o_all = @o_folder.folders
      end  
    else
      @o_all = current_user.folders.parent_folders
    end
    
    render action: 'index'
  end
  
  # GET /folders/1
  # GET /folders/1.json
  def show
  end

  # GET /folders/new
  def new
    @o_single = Folder.new
  end

  # GET /folders/1/edit
  def edit
  end

  # POST /folders
  # POST /folders.json
  def create
    @o_single = Folder.new(folder_params)     
    respond_to do |format|
      if @o_single.save
        
        if params[:folder] and params[:folder][:file_path]
          @o_single.file_size = @o_single.file_path.size.to_f          
          @o_single.file_content_type = params[:folder][:file_path].content_type
          @o_single.name = @o_single.file_path.filename
          @o_single.is_folder = false
          @o_single.save
          session[:folder_temp_id] = @o_single.id
        end
        
        r_url = session[:parent_folder_id] ? sub_folders_url(session[:parent_folder_id]) : folders_url
        format.html { redirect_to r_url, notice: t("general.successfully_created") }
        format.json { render action: 'show', status: :created, location: @o_single }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      if @o_single.update_attributes(folder_params)
        r_url = session[:parent_folder_id] ? sub_folders_url(session[:parent_folder_id]) : folders_url
        format.html { redirect_to r_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      r_url = session[:parent_folder_id] ? sub_folders_url(session[:parent_folder_id]) : folders_url
      format.html { redirect_to r_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @o_single = Folder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit!
    end
    
    def get_records(search, page)
      folder_query = current_user.folders.scoped
      folder_query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
    end    
    
    def set_header_menu_active
      @folders = true
    end
    
    def sort_column
      Folder.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end       
end
