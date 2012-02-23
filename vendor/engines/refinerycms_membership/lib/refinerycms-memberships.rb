require 'refinerycms-base'
require 'refinerycms-dashboard'


module Refinery
  module Memberships
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "memberships"
          plugin.menu_match = /(refinery|admin)\/(memberships|members|membership_emails|membership_email_parts|email_images|roles)$/
        end

        # permissions tap on page editor
        ::Refinery::Pages::Tab.register do |tab|
          tab.name = "Access restrictions"
          tab.partial = "/admin/pages/tabs/roles"
        end

        # this broke as part of config.to_prepare
        # Do this or lost password non-admins still goes to the dashboard
        Refinery::Admin::DashboardController.class_eval do
          old_index = instance_method(:index)
          define_method(:index){|*args|
            if current_user.has_role?(:super_user) || current_user.has_role?(:refinery)
              old_index.bind(self).call(*args)
            else
              redirect_to '/'
            end
          }
        end # Admin::DashboardController.class_eval
      end # config.after_initialize

      refinery.after_inclusion do
        Devise.setup do | config |
          config.mailer = 'MembershipMailer'
        end

        require File.expand_path('../rails_datatables/rails_datatables', __FILE__)
        ActionView::Base.send :include, RailsDatatables

        # make users and members two different classes
        Refinery::User.class_eval do
          set_inheritance_column :membership_level
        end


        Refinery::Role.class_eval do
          has_and_belongs_to_many :pages
          validates_presence_of :title
          acts_as_indexed :fields => [:title]
          # Number of settings to show per page when using will_paginate
          def self.per_page
            12
          end
        end

        #redirect user to the right page after login
        ApplicationController.class_eval do
          protected
          def after_sign_in_path_for(resource_or_scope)

            # if resource_or_scope.class.superclass.name == 'User' ||
              # resource_or_scope.class.name == 'User' ||
              # resource_or_scope.to_s == 'user'
            if (resource_or_scope.instance_of?(User) || resource_or_scope == :user)
              if params[:redirect].present?
                params[:redirect]
              else
                if !resource_or_scope.is_a?(Symbol) && (resource_or_scope.has_role?('Superuser')||resource_or_scope.has_role?('Refinery'))
                  super
                else
                  '/'
                end
              end
            else
              super
            end
          end
        end

        Page.class_eval do
          has_and_belongs_to_many :roles
          attr_accessible :role_ids

          def user_allowed?(user)
            # if a page has no roles assigned, let everyone see it
            if roles.blank?
              true

            else
              # if a page has roles, but the user doesn't or is nil
              if user.nil? || user.roles.blank?
                false

              # otherwise, check user vs. page roles
              else
                # restricted pages must be available for admins
                (roles & user.roles).any? || user.has_role?('Refinery') || user.has_role?('Superuser')

              end
            end
          end
        end # Page.class_eval



        PagesController.class_eval do
          def show
            # Find the page by the newer 'path' or fallback to the page's id if no path.
            @page = Page.find(params[:path] ? params[:path].to_s.split('/').last : params[:id],
              :include => :roles)

            if @page.user_allowed?(current_user) &&
              (@page.try(:live?) ||
                  (refinery_user? and current_user.authorized_plugins.include?("refinery_pages")))

              # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
              if @page.skip_to_first_child and (first_live_child = @page.children.order('lft ASC').where(:draft=>false).first).present?
                redirect_to first_live_child.url
              end
            else
              # redirect to the right login page...
              redirect_to login_members_path(:redirect => request.fullpath, :member_login => true)
            end
          end
        end # PagesController.class_eval

        # show only admins in Users administration
        Refinery::Admin::UsersController.class_eval do
					def index
						find_all_users ["membership_level <> ?", 'Member']
						paginate_all_users
						render :partial => 'users' if request.xhr?
					end
        end

        # override image dialog
        ::Refinery::Admin::DialogsController.class_eval do
          def render(*args)
            if @dialog_type && @dialog_type == 'image'
              if args[0].kind_of?(Hash)
                args[0][:action] = 'admin/memberships/image_dialog'
              end
              super(*args)
            else
              super
            end
          end
        end

        # override image dialog iframe
        Refinery::Admin::ImagesController.class_eval do
          def render(*args)
            if args[0].kind_of?(Hash) && args[0][:action] == 'insert'
              args[0][:action] = 'insert_patched'
              super(*args)
            else
              super
            end
          end
        end

        Refinery::Admin::BaseController.class_eval do
          def restrict_controller
            admin = refinery_user? || current_user.has_role?(:superuser)
            if !admin || Refinery::Plugins.active.reject { |plugin| params[:controller] !~ Regexp.new(plugin.menu_match)}.empty?
              warn "'#{current_user.username}' tried to access '#{params[:controller]}' but was rejected."
              error_404 if admin
              redirect_to '/' unless admin
            end
          end
        end

        require 'memberships/warden_failure'

        # render the right page on login
        ::Devise.setup do |config|
          config.warden do |manager|
            manager.failure_app = Memberships::WardenFailure
          end
        end

        require 'memberships/member'

      end # config.to_prepare
    end # Engine < Rails::Engine
  end # Memberships
end # Refinery
