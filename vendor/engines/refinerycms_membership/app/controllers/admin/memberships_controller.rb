class Admin::MembershipsController < Admin::BaseController
  include Admin::MembershipsHelper
  
  crudify :member,
    :conditions => {:seen => false},
    :title_attribute => :full_name,
    :xhr_paging => true
  
  before_filter do
    columns = [[:last_name, :first_name], [:organization], [:email], [:created_at]]
    params[:order_by] ||= 0
    params[:order_dir] ||= 'asc'
    unless columns[params[:order_by].to_i]
      params[:order_by] = 0
      params[:order_dir] = 'asc'
    end
    if columns[params[:order_by].to_i]
      @order = columns[params[:order_by].to_i].collect{|f| "#{f} #{params[:order_dir]}"}.join(', ')
    end
  end
  
  
  def settings
    @membership_emails = MembershipEmail::find(:all)
    @users = User.where(['membership_level <> ? OR membership_level IS NULL', 'Member']).all
    @roles = Role::find(:all, :conditions => ['title NOT IN (?)',['Superuser','Refinery','Member']])
  end
    
  def save_settings
    params[:settings].each do | key, value |
      logger.debug "#{key} #{value}"        
      value.reject!{|v| !v || v == ''} if value.is_a?(Array)
      RefinerySetting.set(key, value)
    end if params[:settings].present?
    #render :text => "<script>parent.window.$('.ui-dialog .ui-dialog-titlebar-close').trigger('click');</script>"
    render :text => "<script>parent.window.location.reload();</script>"
  end
    
  private
  
  def find_all_members(conditions = {:seen => false})
    @members = Member.where(conditions).order(@order||'')
  end
end
