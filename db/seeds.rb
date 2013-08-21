#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'load super admin'
@admin = User.new(:last_name => 'admin', :first_name => 'admin', :password => 'admin', :password_confirmation => 'admin', :email => 'admin@fileone.com', :is_active => 1)
@admin.save(:validate => false)


puts 'load user roles'
@admin_role = Role.create(:role_type => "SuperAdmin")
@admin.role = @admin_role
Role.create(:role_type => "User")

puts 'load static pages'

help = StaticPage.create(:name => 'Help', 
												:page_route => 'help', 
												:content => "help The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.",
												:is_footer => true
												)

privacy = StaticPage.create(:name => 'Privacy & Terms', 
												:page_route => 'privacy', 
												:content => "privacy The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.",
												:is_footer => true
												)
												
blog = StaticPage.create(:name => 'Blog', 
                        :page_route => 'blog', 
                        :content => "blog The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.",
                        :is_footer => true
                        )