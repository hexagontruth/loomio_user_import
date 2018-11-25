require 'csv'

ActiveAdmin.register_page 'User Import' do

  content do
    render 'admin/csv_upload'
  end

  page_action :import_csv, method: :post do
    contents = params[:import_csv][:file].read
    imported = 0

    CSV.parse(contents, headers: true).each do |row|
      next if (User.find_by(email: row.field('email')))
      result = User.create(row.to_h)
      imported += 1 if result
    end

    redirect_to admin_user_import_path, notice: "Created #{imported} new users"
  end

end
