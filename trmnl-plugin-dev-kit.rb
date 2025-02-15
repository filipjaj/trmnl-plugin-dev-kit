require 'liquid'
require 'sinatra'

VALID_LAYOUTS = ['full', 'half_horizontal', 'half_vertical', 'quadrant']

get '/' do
  erb :index
end

get ['/preview', '/preview/'] do
  redirect to '/preview/full'
end

get '/preview/:layout' do
  redirect to '/preview/full' if valid_layout.nil?

  template = make_template(valid_layout)
  locals = select_variables()
  liquid template, locals: locals
end

def valid_layout
  VALID_LAYOUTS.find { |layout| layout == params[:layout] }
end

def make_template(layout)
  wrapper = File.read(File.join('private', 'preview.liquid'))
  contents = File.read(File.join('layout', "#{layout}.liquid"))
  liquid = Liquid::Template.parse(wrapper)
  liquid.render('layout' => layout, 'contents' => contents)
end

def select_variables
  trmnl = YAML.load_file(File.join('variables', 'trmnl_vars.yml'))

  variables_path = File.join('variables', 'default')
  custom_fields = YAML.load_file(File.join(variables_path, 'custom_fields.yml'))
  user_data = YAML.load_file(File.join(variables_path, 'user_data.yml'))

  trmnl['custom_fields_values'] = custom_fields
  {}.merge(user_data).merge({"trmnl": trmnl})
end
