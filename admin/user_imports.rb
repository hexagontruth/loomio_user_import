require 'csv'

ActiveAdmin.register_page 'User Import' do

  content do
    render 'admin/csv_upload'
  end

  page_action :import_csv, method: :post do
    contents = params[:import_csv][:file].read
    imported = 0
    groups = {}

    CSV.parse(contents, headers: true).each do |row|
      next if (User.find_by(email: row.field('email')))
      attrs = row.to_h
      user_groups = attrs.delete('groups')&.split(',') || []
      attrs[:email_verified] = true
      user = User.create(attrs) or next
      imported += 1
      if !user_groups.empty?
        user_groups.each do |group_name|
          if !groups[group_name]
            groups[group_name] = Group.find_by(name: group_name) || :invalid
          end
          if groups[group_name].is_a? Group
            user.groups.push(groups[group_name])
          end
        end
        user&.save
      end
    end

    redirect_to admin_user_import_path, notice: "Created #{imported} new users"
  end

end