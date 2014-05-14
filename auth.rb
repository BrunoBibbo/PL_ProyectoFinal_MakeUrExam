require 'omniauth'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'omniauth-facebook'
require 'omniauth-github'

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['idGoogle'], config['secretGoogle']
  provider :facebook, config['idfacebook'], config['secretfacebook']
  provider :github, config['idGithub'], config['secretGithub']
end

get '/auth/:provider/callback' do

  session[:auth] = @auth = request.env['omniauth.auth']
  session[:name] = @auth['info'].name
  session[:image] = @auth['info'].image

  if(@auth.provider == 'google_oauth2')
    session[:provider] = 'Google'
  end

  if(@auth.provider == 'facebook')
    session[:provider] = 'Facebook'
  end

  if(@auth.provider == 'github')
    session[:provider] = 'Github'
  end
  
  
  flash[:notice] = %Q{<div class="success">Autenticado en #{session[:provider]} como #{session[:name]}.</div>}
  redirect '/'
end

get '/auth/failure' do
  flash[:notice] = params[:message] 
  redirect '/'
end