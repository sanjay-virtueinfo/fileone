module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def get_all_pages
		StaticPage.footer	
  end
  
  def get_plans
    [["Select", ""]] + Plan.active.collect {|r| [r.usage.to_s + " GB", r.id]}
  end
  
  def get_users
    [["Select", ""]] + User.active.all_users.collect {|r| [r.first_name + " " + r.last_name, r.id]}
  end
  
  def display_file(o_single)
    if o_single.file_content_type.include? "image"
      image_tag o_single.file_path_url(:logo)
    else
      o_single.name
    end
  end    
  
end
