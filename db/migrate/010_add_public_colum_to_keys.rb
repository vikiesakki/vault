if Redmine::VERSION.to_s.start_with?('4')
  class AddPublicColumToKeys < ActiveRecord::Migration[4.2]
    def change
      add_column :keys, :is_public, :boolean, default: false
    end
  end
else
  class AddPublicColumToKeys < ActiveRecord::Migration
    def change
      add_column :keys, :is_public, :boolean, default: false
    end
  end
end
