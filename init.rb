require_dependency "#{Rails.root}/plugins/vault/lib/encryptor"
require_dependency "#{Rails.root}/plugins/vault/lib/redmine_cipher"
require_dependency "#{Rails.root}/plugins/vault/lib/vault_cipher"
require_dependency "#{Rails.root}/plugins/vault/lib/project_patch"
require_dependency "#{Rails.root}/plugins/vault/lib/mk_keyfiles_dir"
require "admin_menu_vault_hooks"

Redmine::Plugin.register :vault do
  name 'Vault plugin'
  author 'noshutdown.ru'
  description 'Plugin for keep keys and passwords'
  version '0.4.1'
  url 'https://noshutdown.ru/redmine-plugins-vault/'
  author_url 'https://noshutdown.ru/'

  project_module :keys do
    permission :export_keys, keys: [ :keys_to_pdf ]
    permission :download_keys, key_files: [ :download ]
    permission :view_keys, keys: [ :index, :edit, :show, :context_menu ]
    permission :edit_keys, keys: [ :index, :new, :create, :edit, :show, :update, :destroy, :copy ]
    permission :manage_whitelist_keys, keys: [ :index, :create, :edit, :show, :update, :copy ]
    permission :whitelist_keys, keys: [ :index, :edit, :show, :context_menu ]
    permission :password_keys, keys: [ :public_keys]
  end

  menu :project_menu, :keys, { controller: 'keys', action: 'index' }, caption: Proc.new {I18n.t('label_module')}, after: :activity, param: :project_id
  settings :default => {
               'empty' => true
           },
           :partial => 'settings/vault_settings'

  menu :admin_menu, :vault, {:controller => 'vault_settings', :action => 'index'}, :caption => :label_vault, :html => {:class => 'icon'}
  menu :top_menu, :passwords, {:controller => 'keys', :action => 'public_keys'}, :caption => "Passwords", :html => {:class => 'icon'}, :if => Proc.new { User.current.admin? || User.current.allowed_to?(:password_keys, nil, :global => true) }
end
