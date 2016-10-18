if defined?(ChefSpec)
  ChefSpec.define_matcher :piwik_plugin

  def install_piwik_plugin(plugin_name)
    ChefSpec::Matchers::ResourceMatcher.new(:piwik_plugin, :install, plugin_name)
  end

  def uninstall_piwik_plugin(plugin_name)
    ChefSpec::Matchers::ResourceMatcher.new(:piwik_plugin, :uninstall, plugin_name)
  end

  def activate_piwik_plugin(plugin_name)
    ChefSpec::Matchers::ResourceMatcher.new(:piwik_plugin, :activate, plugin_name)
  end

  def deactivate_piwik_plugin(plugin_name)
    ChefSpec::Matchers::ResourceMatcher.new(:piwik_plugin, :deactivate, plugin_name)
  end
end
