require 'liquid'
require 'sinatra'

VALID_LAYOUTS = ['full', 'half_horizontal', 'half_vertical', 'quadrant']
PLUGINS_PATH = 'plugins'
CUSTOM_FIELDS_PATH = File.join('variables', 'custom_fields')
USER_DATA_PATH = File.join('variables', 'user_data')
TRMNL_DATA_PATH = File.join('variables', 'trmnl_vars.yml')

get '/' do
  erb :index
end

get ['/preview', '/preview/'] do
  redirect to '/preview/full'
end

get '/preview/:layout' do
  redirect to '/preview' if valid_layout.nil?

  template = make_template(template_variables(valid_layout))
  liquid template, locals: plugin_variables
end

def valid_layout
  VALID_LAYOUTS.find { |layout| layout == params[:layout] }
end

def selected_plugin
  # Try various options in sequence. Param value, first available.
  candidates = [params[:plugin], available_plugins.first]
  puts candidates
  candidates.find { |candidate| available_plugins.include?(candidate) }
end

def selected_custom_fields
  # Try various options in sequence. Param value, "default", first available.
  candidates = [params[:custom_fields], 'default', available_custom_fields.first]
  candidates.find { |candidate| available_custom_fields.include?(candidate) }
end

def selected_user_data
  # Try various options in sequence. Param value, "default", first available.
  candidates = [params[:user_data], 'default', available_user_data.first]
  candidates.find { |candidate| available_user_data.include?(candidate) }
end

def available_plugins
  Dir.glob(File.join('plugins', '*'))
    .select { |path| File.directory?(path) }
    .map { |path| File.basename(path) }
end

def available_custom_fields
  Dir.glob(File.join(CUSTOM_FIELDS_PATH, '*'))
    .map { |path| File.basename(path, '.*') }
end

def available_user_data
  Dir.glob(File.join(USER_DATA_PATH, '*'))
    .map { |path| File.basename(path, '.*') }
end

def make_template(variables)
  wrapper = File.read(File.join('private', 'preview.liquid'))
  liquid = Liquid::Template.parse(wrapper)
  liquid.render(variables)
end

def template_variables(layout)
  contents = File.read(File.join(PLUGINS_PATH, selected_plugin, "#{layout}.liquid"))

  {
    'layout' => layout,
    'contents' => contents,
    'plugin' => selected_plugin,
    'custom_fields' => selected_custom_fields,
    'user_data' => selected_user_data,
    'available_plugins' => available_plugins,
    'available_custom_fields' => available_custom_fields,
    'available_user_data' => available_user_data
  }
end

def plugin_variables
  trmnl = YAML.load_file(TRMNL_DATA_PATH)
  custom_fields = YAML.load_file(File.join(CUSTOM_FIELDS_PATH, "#{selected_custom_fields}.yml"))
  user_data = YAML.load_file(File.join(USER_DATA_PATH, "#{selected_user_data}.yml"))

  trmnl['custom_fields_values'] = custom_fields
  {}.merge(user_data).merge({"trmnl": trmnl})
end
